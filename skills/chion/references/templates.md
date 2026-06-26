# Thin PM Templates

## Worker Dispatch

```text
角色：你是本任务 worker，只做执行，不扩大战场。

任务ID：
- 

目标：
- 

写入范围：
- 

Ponytail 强度：
- full（默认）/ lite / ultra：

执行纪律：
- 先理解任务和真实调用/交互流程，再追求最小改动。
- 先判断是否真的需要改；不需要改就说明原因。
- 先找现有 helper、状态名、组件、测试、调用方、项目惯例。
- 如果是 bug fix，先查相关调用方/入口，优先在共同根因处修，不只补一个表面路径。
- 优先复用现有代码、标准库、平台原生能力、已安装依赖。
- 写最小可靠改动，不为未来需求加抽象、配置、依赖、框架。
- 不为了“看起来完整”补假后端、假数据流、假生产能力。
- 不省掉必要安全、边界、数据保护、可访问性、错误处理。

禁区：
- 不读取或输出 auth.json、cookies、token、localStorage、sessionStorage、password、auth headers。
- 不修改 AGENTS.md，除非用户本轮明确要求。
- 不碰打包产物、node_modules、历史快照，除非本任务明确要求。

背景文件优先级：
- AGENTS.md
- PM_STATE.md
- BOUNDARY.md / README.md
- 当前目标目录里的 PRD、spec、manifest

验收命令：
- 

回传要求：
- 完成后必须回传给 PM。
- 回传状态只能是 DONE / BLOCKED / NEEDS_PM。
- 没有证据路径或验收结果，不算 DONE。

输出格式：
- 任务ID：
- 状态：DONE / BLOCKED / NEEDS_PM
- 改了什么：
- 复用了什么：
- 没有做什么以及原因：
- 证据路径：
- 验收结果：
- 复杂度控制：
- 剩余风险：
- 需要 PM/用户决定：

输出要短：先给结果和证据，再给必要风险；不要粘贴长篇调查过程。
```

## Worker Return Packet

```text
任务ID：
状态：DONE / BLOCKED / NEEDS_PM

结果：
- 

证据：
- 路径或命令：
- 结果：

复杂度控制：
- 复用：
- 跳过：

剩余风险：
- 

需要 PM/用户决定：
- 
```

## Explorer Dispatch

```text
角色：你是 explorer，只读调查，不写文件。

任务ID：
- 

问题：
- 

调查范围：
- 

不要做：
- 不读取或输出任何认证、cookie、token、本地存储、密码、auth header。
- 不跑长测试，不改代码。

输出格式：
- 任务ID：
- 状态：DONE / BLOCKED / NEEDS_PM
- 结论：
- 关键证据路径：
- 推荐下一步：
- 不确定点：
```

## Reviewer Verdict

```text
任务ID：

结论：PASS / FAIL / NEEDS_FIX

功能证据：
- 路径或命令：
- 看到的结果：

复杂度验收：
- 是否复用了现有模式：
- 是否新增不必要抽象/依赖/配置：
- 是否有可删除或可缩小的改动：
- 是否做了超出当前需求的未来功能：

Ponytail-review 发现：
- delete:
- stdlib:
- native:
- yagni:
- shrink:
- net: -N lines possible / Lean already. Ship.

问题：
- 

剩余风险：
- 

建议：
- 
```

Use `PASS` only when the requested scope is satisfied, evidence is concrete, root cause is addressed when relevant, and complexity is justified. Use `NEEDS_FIX` when the direction is right but behavior, evidence, scope, root-cause placement, or complexity needs correction. Use `FAIL` when the work misses the goal, violates boundaries, overbuilds in a way that cannot be trusted, or cannot be verified.

## Patrol Check

```text
巡查目标：
- 

检查项：
- PM 是否仍在调度而不是变 worker：
- 当前阶段是否清楚：
- 风险是否被记录：
- 已派发 worker 是否都有 DONE / BLOCKED / NEEDS_PM 回传：
- 是否存在 UNKNOWN 未回传任务：
- worker/reviewer 输出是否有证据：
- worker 是否遵守最小可靠改动：
- bug fix 是否修根因而不是补症状：
- reviewer 是否同时验功能和复杂度：
- reviewer 是否给出 ponytail-review 标签或 Lean already：
- 是否越过产品边界或触碰禁区：

输出：
- 健康度：OK / WATCH / RISK
- 发现：
- UNKNOWN 任务：
- 建议下一步：
```

## Handoff

```text
业务意义：
当前阶段：
目标目录：
已完成：
未完成：
关键证据：
已派发未回传：
风险/禁区：
下一步：
需要用户决定：
```

Keep handoff concise. Do not paste full history. Point the next agent to current state files and evidence paths.

## Lost-Context Recovery

```text
先读：
1. AGENTS.md
2. PM_STATE.md
3. BOUNDARY.md
4. README.md
5. 最新目标目录和用户本轮指定文件

不要默认做：
- 翻全量历史对话
- 扫所有旧原型目录
- 读取运行态认证数据
- 用猜测替代边界文件
```
