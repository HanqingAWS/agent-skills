# Amazon SES Expert Skill

`ses-expert` 是一个轻量、交互式的 Amazon SES Skill，适用于 Codex、Claude Code
及其他能够执行命令和分析日志的 Agent。

它不捆绑 Python、Node.js 或固定脚本。Agent 读取一个 `SKILL.md`，根据用户提供的
截图、退信码、DNS、代码和 AWS 环境，现场生成并执行所需的 `dig`、AWS CLI、SQL、
Shell 或日志查询。

## 目录

```text
ses-expert/
├── SKILL.md
└── README.md
```

## 能处理的问题

- SPF、Easy DKIM、DMARC 对齐和自定义 MAIL FROM
- 发件域 MX、邮箱别名和 sender verification
- Microsoft `550 5.7.515`
- Gmail `550 5.7.1 unsolicited mail`
- GMX/WEB.DE policy、DNS 和限流退信
- 无效邮箱、邮箱已满、临时退信和永久退信
- SES 抑制列表的分类与选择性解除
- 配置集、身份反馈通知、SNS/SQS 和重复事件
- Delivery/Open/Click 缺失或统计错误
- SES 滚动24小时额度和大批量发送计划
- 新域名预热、信誉恢复和服务商分流
- 多项目、多环境、配置集和 SES Tenant 设计

## 安装

### Codex

```bash
cp -R ses-expert "${CODEX_HOME:-$HOME/.codex}/skills/"
```

### Claude Code

```bash
cp -R ses-expert "$HOME/.claude/skills/"
```

显式调用：

```text
$ses-expert
```

## 交互方式

Agent 应当：

1. 先阅读用户提供的截图、日志、退信事件或代码；
2. 判断问题处于 API、认证、收件地址、信誉、事件链路还是额度层；
3. 信息不足时只追问一个最关键问题；
4. 根据现场环境生成最小的只读验证命令；
5. 解释验证结果并提出可回滚、可复测的修复方案；
6. 用户需要客户回复时，再输出一段简短口径。

示例命令由 Agent 动态生成：

```bash
dig +short MX mail.example.com
dig +short TXT _dmarc.mail.example.com
dig +short MX ses.mail.example.com
```

```bash
aws ses get-send-quota --region us-west-2
aws sesv2 get-email-identity \
  --email-identity mail.example.com \
  --region us-west-2
```

如果环境允许，Agent 可以创建临时脚本来批量验证；Skill 本身保持 Markdown-only。

## 示例提示词

```text
Use $ses-expert to diagnose why Outlook returns
SPF=Pass, DKIM=Pass, DMARC=Fail and 550 5.7.515.
```

```text
用 $ses-expert 验证 mail.example.com 的 DKIM、DMARC、
自定义 MAIL FROM 和接收 MX 是否正确。
```

```text
用 $ses-expert 分析这些 diagnosticCode，
区分无效邮箱、发送方配置、临时错误和信誉拦截。
```

```text
用 $ses-expert 排查为什么 Delivery 已进入 SQS，
但 Open 和 Click 一直是0。
```

```text
用 $ses-expert 为80万收件人制定分阶段发送计划。
SES额度为100万/滚动24小时、300封/秒。
```

## 核心原则

- `Send` 只表示 SES 接受请求。
- `Delivery` 只表示收件服务器接受，不代表进入收件箱。
- SPF、DKIM通过但未对齐时，DMARC仍可失败。
- `550` 不是单一原因，必须读取增强状态码和 `diagnosticCode`。
- 日志 hits 和 SQS receive 不是唯一邮件数。
- 发送方 DNS/认证失败不能用于判定收件邮箱无效。
- 抑制列表只能分类后选择性解除，不能整表清空。
- SES额度是技术上限，不是新域名的推荐发送速率。

## 验证

使用 Codex Skill Creator 的校验器：

```bash
python3 quick_validate.py ses-expert
```

还应检查：

- 文件夹名和 frontmatter 均为 `ses-expert`；
- 没有 TODO 或脚手架占位符；
- 官方文档链接仍有效；
- Agent 会主动生成验证命令，而不是猜测结果；
- 生产变更前会说明风险并请求授权。

## 可移植性

此 Skill 只依赖 Markdown，不强制要求：

- Python 或 Node.js
- MCP Server
- 固定 AWS 账号
- 预装 DNS 脚本

有工具时 Agent 可以直接验证；没有工具时，应输出可复制命令并明确哪些事实尚未验证。
