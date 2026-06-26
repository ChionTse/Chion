# Worker Dispatch Example

```text
角色：你是本任务 worker，只做执行，不扩大战场。

任务ID：W1

目标：
- 修复 Top5 drawer 备注保存后不刷新的问题。

写入范围：
- electron_launcher_p6.46_waiting_game_hud_persist_records_20260625/src

Ponytail 强度：
- full

执行纪律：
- 先理解任务和真实调用/交互流程，再追求最小改动。
- 如果是 bug fix，先查相关调用方/入口，优先在共同根因处修。
- 优先复用现有代码、标准库、平台原生能力、已安装依赖。
- 写最小可靠改动，不为未来需求加抽象、配置、依赖、框架。

验收命令：
- npm run smoke

回传要求：
- 状态只能是 DONE / BLOCKED / NEEDS_PM。
- 没有证据路径或验收结果，不算 DONE。
```
