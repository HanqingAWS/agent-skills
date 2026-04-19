---
name: web-ppt
description: Generate a single-file interactive HTML slide deck (web-based PPT) from a conversational brief. ONLY triggers when the user explicitly mentions "web-ppt" (with or without slash) — e.g. "/web-ppt", "用 web-ppt 做一个...", "web-ppt 帮我生成一个幻灯片", "试试 web-ppt". Do NOT trigger on generic PPT / 幻灯片 / slides / slide deck / 演示文稿 requests — the user has other PPT-related skills and will name this one explicitly when they want it. If the user asks for a PPT without saying "web-ppt", do not invoke this skill.
---

# 网页版 PPT 生成器（对话式）

交付物：**一个双击即可打开的 `.html` 文件**，具备键盘翻页、全屏、概览、进度条——**不是**滚动长页，而是**逐页切换**的演示稿。

---

## 第一原则：先对话，再出稿

收到请求后，**绝对不要立刻写代码**。这是一个对话式技能，用户选择它是因为想和 Claude **共创**，而不是看它一次性乱猜。

### 三阶段流程

**阶段 A · 澄清需求（用 AskUserQuestion）**

如果用户原始请求里下列任何一项缺失，就问。最多 1 次 AskUserQuestion，一次问 2-4 题：

1. **受众 & 目的** — 给谁看？要让他们记住什么 / 做什么？
2. **页数与节奏** — 5-8 页 / 10-15 页 / 更长？对应几分钟？
3. **主题风格** — 从下方目录选一套，或用户自述
4. **核心内容是否已经具备** — 用户口述要点 / Claude 根据主题自行起草 / 从某个文件抽取

如果用户的第一句话已经把这些全交代清楚（例："帮我做一个 Q2 复盘 8 页，极地主题，给管理层看，内容我来口述"），就跳过，直接进阶段 B。

**阶段 B · 大纲确认（markdown，不是 HTML）**

根据阶段 A 收集到的信息，给出一份 **markdown 大纲**：

```
## 大纲草稿（共 N 页）
1. 封面 · [标题] · [副题关键词]
2. 章节分隔 · [章节名]
3. 巨号数据 · [核心数字]
4. 两栏对比 · Before / After
...
```

每页只给**标题 + 关键词 + 布局类型**，不要写满。让用户能一眼扫过，提"第 3 页换成引用吧"、"多加一页 xxx"。

**阶段 C · 出稿**

用户 OK 大纲后，才开始写完整 HTML。写完用 `open <path>` 在浏览器打开，用极简一行告知快捷键。

---

## 主题目录（承诺一套，不要混搭元素）

每套主题都有**明确的字体、配色、氛围**。选一套就全程贯彻——不要把编辑杂志的衬线配到霓虹主题上。

### 1. 极地科技 · Arctic Tech
- **配色**：深海军蓝 `#06111f` · 冰青 `#7dd3fc` · 极光紫 `#c4b5fd` · 极光青绿 `#5eead4`
- **字体**：Fraunces 斜体 + Noto Serif SC 900（显示）；Noto Sans SC 300-400（正文）；JetBrains Mono（技术）
- **氛围**：radial blur 极光、发丝网格、雪花粒子、细长 hairline 分隔线
- **适用**：AI / 云 / 技术产品、架构讲解、工程复盘

### 2. 编辑杂志 · Editorial
- **配色**：米白 `#faf7f2` · 墨黑 `#1a1a1a` · 砖红 `#8b2e1c` · 深绿 `#2d4a3e` 点缀
- **字体**：EB Garamond / Fraunces（大号显示）+ Noto Serif SC 600-900；正文 Noto Serif SC 400；**禁用 Inter/Roboto**
- **氛围**：大号斜体引号、细横线、首字下沉、大面积留白，《纽约客》/《经济学人》式
- **适用**：战略、研究、执行层汇报、思想性内容

### 3. 夜市霓虹 · Neon Market
- **配色**：近黑 `#0a0a0a` · 电粉 `#ff2d95` · 柠黄 `#eeff41` · 极光青 `#00ffd1`
- **字体**：Archivo Black / Space Grotesk 800（显示）+ 思源黑体 Heavy；正文 Space Grotesk 500；JetBrains Mono
- **氛围**：硬边几何、半调网点、CRT 扫描线、超大数字、黑色实心色块
- **适用**：产品发布、大胆宣告、年会开场、Brand-forward

### 4. 手作便签 · Paper Notes
- **配色**：牛皮纸 `#f0e6d2` · 墨蓝 `#2d3e50` · 橙红印章 `#d14f3a` · 薄荷绿 `#8fbc8f`
- **字体**：Caveat / LXGW WenKai（手写标题）+ Noto Serif SC；Courier Prime（打字机）
- **氛围**：纸纹、胶带、便签贴、下划波浪线、手绘箭头
- **适用**：工作坊、创意评审、回顾会、非正式分享

**如果用户描述了目录外的风格**（例："我想要 80 年代复古游戏感"），自行设计。但仍要遵守"承诺一套 + 全片一致"。

---

## 幻灯片布局类型（必须轮换）

坏 PPT 的通病：10 页都是"标题 + 3 条 bullet + 卡片"。好 PPT 的秘诀是**布局持续变化**。

| 类型 | 典型内容 | 视觉要点 |
|------|---------|---------|
| **封面** | 标题 + 副题 + 元数据 | 大字号（48-96px 以上），显示字体，留白 |
| **章节分隔** | 章节编号 + 章节名 | 巨号 "01" / "02"，占半屏，极少文字 |
| **巨号数据** | 一个关键数字 | 数字占 60% 屏幕，单位和注释极小 |
| **大字引用** | 核心观点一句话 | 超大斜体衬线，边框引号，几乎空白 |
| **两栏对比** | Before/After、旧/新 | 左右分栏，中间分隔线或箭头 |
| **三立柱** | 三个并列要点 | **整套 deck 最多一次**，用多了就俗 |
| **流程图** | 步骤 / 架构 / 时间线 | SVG 或 div 手画连接线，节点可高亮 |
| **代码/终端** | 命令、配置、代码 | 终端窗口外观 + 语法着色 + 单色背景 |
| **图表占位** | bar / line / donut | 纯 CSS 或 SVG，不要 iframe 外部 |
| **媒体聚焦** | 大图 + 一句标注 | 图占 70%+，文字一行 |
| **时间线** | 带日期的节点 | 垂直或水平时间线 |
| **清单列表** | 5-10 项目 | 带编号 01-10，每行一个细节 |
| **结尾 CTA** | 感谢 / 联系 / 下一步 | 大 CTA 按钮 + 简短邀约 |

**硬性规则**：
- 相邻两页不能是同一布局类型
- 超过 10 页的 deck，"三立柱"和"标题+bullet"总共不能超过 3 页

---

## 必备交互（所有主题通用）

```
键盘：
  → / Space / PageDown / Enter   下一页
  ← / PageUp                      上一页
  Home                            第一页
  End                             最后一页
  F                               全屏切换
  O / Escape                      概览模式（网格缩略图）
  ?                               快捷键帮助浮层

触屏：
  左滑 下一页 · 右滑 上一页

UI：
  右下：当前页 / 总页数
  顶部：细进度条（按百分比填充）
  概览模式：CSS Grid 所有页缩略图，点击跳转
```

### JS 参考骨架（按需改写，不要原样照抄）

```javascript
const slides = document.querySelectorAll('.slide');
const counter = document.querySelector('.counter');
const progress = document.querySelector('.progress-bar');
let cur = 0;

function go(i) {
  cur = Math.max(0, Math.min(slides.length - 1, i));
  slides.forEach((s, idx) => s.classList.toggle('active', idx === cur));
  counter.textContent = `${String(cur+1).padStart(2,'0')} / ${String(slides.length).padStart(2,'0')}`;
  progress.style.width = `${(cur+1) / slides.length * 100}%`;
}

document.addEventListener('keydown', (e) => {
  const inOverview = document.body.classList.contains('overview');
  if (e.key === '?') { document.querySelector('.help').classList.toggle('show'); return; }
  if (e.key === 'o' || e.key === 'O' || (e.key === 'Escape' && inOverview)) {
    document.body.classList.toggle('overview'); return;
  }
  if (inOverview) return;
  if (['ArrowRight',' ','PageDown','Enter'].includes(e.key)) { e.preventDefault(); go(cur+1); }
  else if (['ArrowLeft','PageUp'].includes(e.key)) go(cur-1);
  else if (e.key === 'Home') go(0);
  else if (e.key === 'End') go(slides.length-1);
  else if (e.key === 'f' || e.key === 'F') {
    document.fullscreenElement ? document.exitFullscreen() : document.documentElement.requestFullscreen();
  }
});

// touch
let tx = 0, ty = 0;
addEventListener('touchstart', e => { tx = e.touches[0].clientX; ty = e.touches[0].clientY; });
addEventListener('touchend', e => {
  const dx = e.changedTouches[0].clientX - tx;
  const dy = e.changedTouches[0].clientY - ty;
  if (Math.abs(dx) > 50 && Math.abs(dx) > Math.abs(dy)) go(cur + (dx < 0 ? 1 : -1));
});

// overview click-to-jump
slides.forEach((s, i) => s.addEventListener('click', () => {
  if (document.body.classList.contains('overview')) {
    document.body.classList.remove('overview');
    go(i);
  }
}));

go(0);
```

### CSS 核心结构（按需改写）

```css
body { overflow: hidden; margin: 0; }
.deck { width: 100vw; height: 100vh; position: relative; }
.slide {
  position: absolute; inset: 0;
  display: flex; flex-direction: column; justify-content: center;
  padding: 6vh 8vw;
  opacity: 0; pointer-events: none;
  transition: opacity 0.5s, transform 0.5s;
  transform: translateX(40px);
}
.slide.active { opacity: 1; pointer-events: auto; transform: translateX(0); }

/* overview mode */
body.overview .deck {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  padding: 32px;
  overflow: auto;
  height: auto;
  min-height: 100vh;
}
body.overview .slide {
  position: relative;
  opacity: 1; transform: none; pointer-events: auto;
  height: 200px; padding: 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: transform 0.2s;
}
body.overview .slide:hover { transform: scale(1.03); }
body.overview .slide.active { outline: 2px solid currentColor; }
body.overview .slide * { font-size: 0.35em !important; }

/* 16:9 letterbox（可选） */
@media (min-aspect-ratio: 16/9) {
  .deck { aspect-ratio: 16/9; max-width: 100vw; max-height: 100vh; margin: auto; }
}
```

---

## 必做

- **16:9 基准**，屏幕比例不符时居中 letterbox
- 每页独立 `<section class="slide" data-slide="N" data-layout="TYPE">`，其中：
  - `data-slide="N"` 是稳定编号（1 起计，不随增删改变已有页的号）
  - `data-layout="TYPE"` 标注布局类型（`cover` / `quote` / `stat` / `two-col` / `flow` / `code` ...），方便后续定位和替换
  - 每页内部用 HTML 注释标一行索引头，如 `<!-- Slide 03 · 巨号数据 · ARR 增长 -->`，方便 Edit 工具精确定位
- 用 `.active` class 控制显示
- 统一的进出场动效（选一种：slide-left / fade / zoom），**整个 deck 保持一致**
- Google Fonts 可外链 `<link>`，其他资源全部内联（CSS/JS/SVG）
- 文件名默认 `<主题关键词>-slides.html`，保存到用户指定路径或当前工作目录
- 生成后用 `open <path>` 在浏览器打开
- 收尾消息极简：一行文件路径 + 一行快捷键 + 一句**"想改哪页直接说，例如'把第 3 页改成引用'"**（告知用户可迭代）

## 必避（反模式）

- ❌ 每页底部的 logo / 分页号栏（"公司模板"感的元凶）
- ❌ 连续 3 页以上同一版式（三列卡片尤其劣质）
- ❌ bullet 前加 ✓ ✅ ⭐ 💎 等填充 emoji
- ❌ "紫色渐变 on 白底"——最俗的 AI 组合
- ❌ 为了花哨加无意义的：粒子、时钟、滚动新闻条
- ❌ 默认 Inter / Roboto / Arial / 系统字体
- ❌ 把已有 deck 的样式原样拷贝——每次都要重写 CSS
- ❌ 跳过对话阶段直接写 HTML

---

---

## 迭代微调（生成后的多轮修改）

出稿 ≠ 结束。用户会**按页号指着改**——这是对话式 skill 的精髓。

### 基本规则

1. **永远用 Edit 工具，不要用 Write 重写整个文件**。只改用户点名的页或样式。
2. **按 `data-slide="N"` 或注释头定位**，找到目标 `<section>` 后再改。
3. **改完告诉用户你具体改了什么**，一句话，不要列完整 diff。用户可以 Cmd+R 刷新浏览器查看。
4. **文件已经打开在浏览器里**，不要重复 `open`——除非用户明确说"重新打开"。

### 常见修改类型与处理

| 用户说 | 操作 |
|-------|------|
| "第 3 页改成引用" | 把 slide 3 的布局类型换掉，`data-layout` 改为 `quote`，内容重写为大字引用版式 |
| "第 1 页副标题改成 X" | 只 Edit 这一行文本，其他不动 |
| "第 5 页和第 6 页顺序换一下" | 调换两个 `<section>` 的位置；`data-slide` 编号**跟随位置重排** (1→N 连续)，JS 靠 DOM 顺序 |
| "把整体配色换成暖色" | 改 `:root` 里的 CSS 变量，其他不动 |
| "第 4 页加一行补充" | 在对应 section 内新增一个元素，保持原布局 |
| "第 7 页后再加一页讲 X" | 插入新 `<section data-slide="..."`>，**重排后续页的 `data-slide`** |
| "删掉第 2 页" | 删除对应 section，**重排后续页编号** |
| "动效慢一点" | 改 `.slide` 的 `transition` 时长，全局生效 |

### 迭代过程中的禁忌

- ❌ 用户说"改第 3 页"却把第 2、第 4 页也顺手"优化"了
- ❌ 趁机把主题换了（除非用户明说）
- ❌ 加/删页后**忘了重排 `data-slide` 编号**，导致用户下次说"第 5 页"时错位
- ❌ 一次改太多——用户要微调，不是要返工

### 举例

> **User**（已有 10 页 deck）: 把第 3 页的三列改成一个大号数据，就 $42M ARR

**Claude** 用 Grep 找到 `data-slide="3"` 的 section，Edit 替换整个 `<section>` 的内容：把三列布局换成巨号数据布局，`data-layout="stat"`，数字是 `$42M`，副标 `ARR 2025`。改完回一句："第 3 页已替换为 `$42M ARR` 巨号数据版式，Cmd+R 刷新查看。"

---

## 对话示例

> **User**: 帮我做一个讲 Q2 团队复盘的 PPT

**Claude** 调用 AskUserQuestion：
- 受众：管理层汇报 / 团队内部分享 / 跨部门
- 页数：5-8 页（5 分钟）/ 10-15 页（15 分钟）
- 主题：极地科技 / 编辑杂志 / 霓虹 / 便签
- 内容：我来口述要点 / Claude 根据通用复盘结构起草

> **User**: 管理层 / 10 页 / 编辑杂志 / 根据复盘结构起草，核心是做了 3 个项目，其中 A 超预期，B 卡在外部依赖，C 下季度继续

**Claude** 给出大纲（10 页 markdown），标注每页布局类型，等用户确认。

> **User**: 第 7 页换成引用，其他 OK

**Claude** 写 HTML，保存到 `q2-review-slides.html`，浏览器打开，收尾：

```
文件: /Users/.../q2-review-slides.html
← → 翻页 · F 全屏 · O 概览 · ? 帮助
```
