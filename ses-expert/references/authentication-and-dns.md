# SES Authentication and DNS

Use this reference for SPF, DKIM, DMARC, custom MAIL FROM, MX, sender verification,
and authentication-related SMTP errors.

## Identity layers

Keep these names distinct:

- RFC 5322 From: visible address, for example `team@mail.example.com`.
- DKIM signing domain: `d=` in `DKIM-Signature`.
- RFC 5321 MAIL FROM: envelope/bounce domain used by SPF.
- Reply-To: where human replies go; it does not authenticate the sender.
- Receiving MX: where mail addressed to the visible From domain is delivered.

DMARC passes when at least one of SPF or DKIM both passes and aligns with the RFC 5322
From domain. `SPF=Pass, DKIM=Pass, DMARC=Fail` means the passing identities did not align.

## Recommended SES setup

For `team@mail.example.com`:

1. Verify `mail.example.com` as an SES identity.
2. Enable Easy DKIM and publish all SES-provided CNAME records.
3. Use a separate custom MAIL FROM subdomain, such as
   `ses.mail.example.com`.
4. Publish the exact SES-provided records on that MAIL FROM subdomain:

   ```text
   MX  10 feedback-smtp.<region>.amazonses.com
   TXT v=spf1 include:amazonses.com ~all
   ```

5. Publish DMARC at `_dmarc.mail.example.com`. Start with `p=none` for observation,
   then move to `quarantine` or `reject` only after all legitimate senders align.
6. If the visible From address is expected to receive replies, give
   `mail.example.com` a valid enterprise-mail MX and create the actual mailbox or alias.

The visible From domain and custom MAIL FROM domain are different DNS labels and can
coexist:

```text
mail.example.com      -> enterprise mailbox MX
ses.mail.example.com  -> SES feedback MX and SES SPF
```

Do not point the visible From domain's receiving MX at the SES feedback endpoint.

## Why a visible sender domain should receive mail

SMTP does not universally require every visible From domain to host a mailbox, but some
receivers perform sender or domain verification. They can reject with:

```text
550 invalid DNS MX or A/AAAA resource record
550 non-local sender verification failed
501 Mail From Domain does not include a usable MX or A entry
553 Domain of sender address does not exist
```

For broad international delivery, publish valid MX records and ensure the visible From
mailbox or alias exists.

## DMARC policy is not the DMARC result

- `p=none`: request monitoring, but receivers may still independently reject unauthenticated
  or suspicious traffic.
- `p=quarantine`: request spam/quarantine treatment for failures.
- `p=reject`: request rejection for failures.

A domain with `p=none` can still produce `DMARC=Fail`.

## Common incident: Microsoft 550 5.7.515

Example:

```text
550 5.7.515 Access denied ... SPF=Pass, DKIM=Pass, DMARC=FAIL
```

Diagnosis:

1. Inspect `smtp.mailfrom`, DKIM `header.d`, and `header.from`.
2. Confirm Easy DKIM signs with an aligned domain.
3. Confirm SES is using the custom MAIL FROM rather than falling back to
   `amazonses.com`.
4. Prefer the SES option that rejects on MAIL FROM MX failure when silent fallback would
   break the organization's authentication requirement.
5. Retest a new message. Historical bounces do not change after DNS is fixed.

## DNS-change validation

Saving a DNS record in a console does not prove global visibility. Before a bulk send:

```bash
dig +short MX mail.example.com
dig +short TXT _dmarc.mail.example.com
dig +short MX ses.mail.example.com
dig +short TXT ses.mail.example.com
```

Also query independent public resolvers. If a previous result was NXDOMAIN, allow for
negative caching and verify new mail timestamps rather than bounce-notification timestamps.

## Official references

- SES email authentication:
  https://docs.aws.amazon.com/ses/latest/dg/email-authentication-methods.html
- Custom MAIL FROM:
  https://docs.aws.amazon.com/ses/latest/dg/mail-from.html
- DMARC:
  https://docs.aws.amazon.com/ses/latest/dg/send-email-authentication-dmarc.html
