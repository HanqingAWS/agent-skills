#!/usr/bin/env bash
set -u

usage() {
  cat <<'EOF'
Usage:
  check_ses_dns.sh FROM_DOMAIN AWS_REGION [MAIL_FROM_DOMAIN] [DKIM_SELECTORS]

Examples:
  check_ses_dns.sh mail.example.com us-west-2 ses.mail.example.com
  check_ses_dns.sh mail.example.com us-west-2 ses.mail.example.com sel1,sel2,sel3

Requires: dig
EOF
}

if [[ $# -lt 2 || $# -gt 4 ]]; then
  usage >&2
  exit 2
fi

if ! command -v dig >/dev/null 2>&1; then
  echo "ERROR: dig is required." >&2
  exit 2
fi

from_domain="${1%.}"
region="$2"
mail_from="${3:-}"
selectors="${4:-}"
warnings=0
errors=0

section() {
  printf '\n== %s ==\n' "$1"
}

show_records() {
  local type="$1"
  local name="$2"
  local output
  output="$(dig +short "$type" "$name" 2>/dev/null || true)"
  printf '%-7s %-42s %s\n' "$type" "$name" "${output:-<none>}"
}

has_record() {
  local type="$1"
  local name="$2"
  [[ -n "$(dig +short "$type" "$name" 2>/dev/null || true)" ]]
}

section "Visible From domain"
show_records MX "$from_domain"
show_records A "$from_domain"
show_records AAAA "$from_domain"
show_records TXT "$from_domain"
show_records TXT "_dmarc.$from_domain"

if ! has_record MX "$from_domain" &&
   ! has_record A "$from_domain" &&
   ! has_record AAAA "$from_domain"; then
  echo "WARN: From domain has no MX or A/AAAA record; some receivers may reject sender verification."
  warnings=$((warnings + 1))
fi

if ! has_record TXT "_dmarc.$from_domain"; then
  echo "ERROR: No DMARC TXT record found at _dmarc.$from_domain."
  errors=$((errors + 1))
fi

if [[ -n "$mail_from" ]]; then
  section "Custom MAIL FROM"
  show_records MX "$mail_from"
  show_records TXT "$mail_from"

  expected="feedback-smtp.${region}.amazonses.com"
  mx="$(dig +short MX "$mail_from" 2>/dev/null || true)"
  spf="$(dig +short TXT "$mail_from" 2>/dev/null || true)"

  if [[ "$mx" != *"$expected"* ]]; then
    echo "ERROR: MAIL FROM MX does not reference $expected."
    errors=$((errors + 1))
  fi
  if [[ "$spf" != *"include:amazonses.com"* ]]; then
    echo "ERROR: MAIL FROM TXT does not authorize amazonses.com."
    errors=$((errors + 1))
  fi
fi

if [[ -n "$selectors" ]]; then
  section "DKIM selectors"
  IFS=',' read -r -a selector_list <<< "$selectors"
  for selector in "${selector_list[@]}"; do
    selector="${selector//[[:space:]]/}"
    [[ -z "$selector" ]] && continue
    name="${selector}._domainkey.${from_domain}"
    show_records CNAME "$name"
    if ! has_record CNAME "$name"; then
      echo "ERROR: Missing DKIM CNAME for selector $selector."
      errors=$((errors + 1))
    fi
  done
else
  section "DKIM selectors"
  echo "INFO: No selectors supplied. Read them from the SES identity and rerun for deterministic validation."
fi

section "Result"
printf 'errors=%d warnings=%d\n' "$errors" "$warnings"

if (( errors > 0 )); then
  exit 1
fi
