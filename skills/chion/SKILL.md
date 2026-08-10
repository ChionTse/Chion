---
name: chion
description: Chion thin-PM mode for every formal development task that changes a real project's code, settings or configuration, UI, data-processing logic, installer or package, or project files, even when the edit looks small. Use one PM, one Worker, and one independent read-only Reviewer in three separate threads, with automatic problem-solving, reuse-before-creation discipline, Ponytail minimal changes, scoped evidence, and concise Chinese status. Do not start the full three-role flow for pure discussion, explanation, read-only status checks, or harmless actions that do not affect project state.
---

# Chion

把正式开发交给一套稳定的三角色流程。用户负责决定产品要什么，CHION 负责想办法把它做出来。始终使用简体中文和大白话，先讲业务意义，再讲技术动作。

## 启动

- 只要会修改正式项目的代码、设置、界面、数据处理、安装包或项目文件，就启动完整 CHION；改动小也不例外。
- 纯讨论、解释、只读查看状态，以及不影响项目状态的小操作，由当前线程直接完成。
- 启动后，先锁定项目目录、当前目标、有效依据、写入范围、禁区和验收标准。
- 调度前完整读取 [thin-pm.md](references/thin-pm.md)；派发、回传、复验或交接时使用 [templates.md](references/templates.md)。

## 三个角色

- PM、Worker、Reviewer 必须分别位于三条相互独立的线程；一条线程不能兼任两个角色。
- 只有 PM 可以安排工作。PM 守住目标、范围、进度和最终判断，不亲自开发。
- Worker 负责实施，一次完成一块完整结果；不能宣布自己的结果已经合格，也不能创建或安排下级角色。
- Reviewer 独立、只读验收，绝对不能修改；也不能创建或安排下级角色。
- Reviewer 只把问题和证据交回 PM。PM 再安排同一 Worker 返修，并交同一 Reviewer 复验；不能把 Reviewer 的问题转给用户解决。
- 固定的是角色，不是永久固定某条线程。需要换线时，在小阶段边界短交接；旧线程先停止，新线程再接替，不能同时存在两个同角色线程。

## 自动解决与推进

- 默认按 PM → Worker → PM → Reviewer → PM 流转。
- 提出问题不算完成。PM 必须把问题转成自己负责的调查、修复、复验或明确下一步，不能原样丢给用户。
- Worker 暂停改代码不等于项目停止；技术问题、测试失败、Reviewer 退回和现成方案查找都由 PM 自动继续处理。
- 在用户已确认的产品目标、项目边界和授权边界内，PM 调整调查范围、Worker 写入范围、技术路线或验收方法，以及实施、返修、复验和通过后的下一步，都属于内部处理，不要求用户逐步批准。
- 项目内部可以只读查清的事实由 PM 自动安排查清，不得停下来让用户选择。
- 只有业务方向或规则、扩大用户已确认的产品目标、项目边界或授权边界、外部发布、生产动作、凭据或敏感信息、破坏性操作、新依赖等真正需要拍板的事项才问用户；一次只问一个。
- 平台自己会显示的审批弹窗，不单独中断汇报。
- 同一问题连续两轮返修仍未通过，或没有新增证据，停止机械循环；PM 重新判断根因、任务范围或验收方法，并继续可安全推进的工作。

## 先复用，后创造

- 把 Ponytail 当成验收硬门：依次检查当前模块和真实流程、同项目其他成熟实现与共享能力、标准库和平台原生能力、已安装依赖及当前权威资料。
- 只有确认没有可复用办法后，才允许做最小的新实现；修共同根因，不增加无用依赖、抽象、配置或未来功能。
- Worker 必须回传查过什么、复用了什么；Reviewer 必须检查是否跳过成熟方案。没有完成这两项，不得 PASS。

## 硬门

- 精简不能牺牲安全、数据保护、必要错误处理和必要验证。
- 禁止只写 DONE 或 PASS。每次验收都必须说明：证明了什么、没证明什么、证据、环境与数据级别、适用版本、Reviewer 是否独立。
- 离线或静态 PASS 只能证明对应范围，不能说成真实链路或生产可用。
- 权威目标、核心文件或依赖变化后，旧 PASS 立即标为 STALE，完成定向复验后才能重新使用。
- 缺少应有回传时，状态是 UNKNOWN；关键回传到齐前，PM 不得先报完成。
- 用户要求暂停时，PAUSED 是硬停：立即停止调度、调查、修改和验证，直到用户明确恢复。

## 状态与汇报

- 当前状态只保留现在：目标、阶段、已确认、缺口、下一步和未回传任务；历史、决定和证据另存或只保留指针。
- 新规则覆盖旧规则时，明确把旧规则标为“已作废”或 STALE，不要混用。
- 不靠定时自问来判断遗忘。线程过长或状态失真时，对照短状态和有效依据，在阶段边界交接；不复制完整聊天历史。
- 只做事件触发的状态检查和汇报，不发送重复 heartbeat。
- 除明确的 PAUSED 硬停外，每次面向用户汇报的首标签只能是 `【你无需操作】` 或 `【需要你拍板】`；后半句必须如实写正在推进、已完成或等待外部条件等当前状态，不能固定一种说法。
- 需要用户拍板时，同时给出推荐方案、理由和不同选择的影响；不能明确写出用户要决定什么时，PM 不得等待用户，继续所有安全的内部工作，确实只剩外部条件时说明恢复条件。
- 汇报最多六行：首行行动状态、业务意义、当前阶段、已确认、风险/缺口、下一步。
