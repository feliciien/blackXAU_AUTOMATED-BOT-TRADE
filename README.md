# blackXAU | MT5 code and price-action research

This is a public **implementation portfolio**, not an audited performance track record. The original H4/M5 EA remains at `blackXAU2.mq5`. It now includes safety guardrails and reproducibility guidance. Historical screenshots from the 2025 README are available in [Git history](https://github.com/feliciien/blackXAU_AUTOMATED-BOT-TRADE/blob/be74ebe2c4ba4f41c8a6a1a899ec73b8d63668f0/README.md), but they are **not** proof of this revised build's performance.

## Source

- [blackXAU2.mq5](blackXAU2.mq5) — H4/daily zone breakout, M5 retest, H1 EMA / ATR options, broker position sizing, limited calendar filter, session controls and trailing stops.
- [Research/FibonacciStudy.mq5](Research/FibonacciStudy.mq5) — independent original MQL5 EA example that detects confirmed pivots and research-only Fib retracement signals; it never sends orders.
- [Validation plan](docs/validation.md) — test matrix and evidence required for real execution acceptance.
- [Automating discretionary trading](docs/discretionary-to-rules.md) — what must be clarified before implementing someone's subjective Fibonacci or price-action strategy.

## Updated safety design

- `EnableTrading=false` and `AllowRealAccount=false` by default. No orders by default.
- Risk-based size enabled by default at 0.25%; broker-specific loss estimated with `OrderCalcProfit`, never forced to min lots when risk would be exceeded.
- Daily equity and peak-equity budget check before attempting an order; terminal-local anchors persist across restarts. These are **not** centralized prop-firm drawdown controls.
- Position and pending-order exclusion by symbol; own-MagicNumber filter on trailing-stop modifications.
- Closed-bar EMA confirmation, ATR-unavailable fail closed, broker stop-distance check, and server retcode/deal inspection.
- Sell code in the legacy EA remains disabled: the enhanced EA is **BUY-only**, not a complete bidirectional implementation.

## What is NOT verified

- No Windows MetaEditor compilation of this change has been witnessed here.
- No fresh MT5 Strategy Tester run has been generated for this change.
- No audited live or out-of-sample PnL is claimed.
- No automated broker execution, compliance certification, or profitability guarantee.

**Research process:** define chart examples -> specify objective conditions -> identify invalidations -> implement EA -> compile -> real-tick tester -> OOS/holdout -> demo execution -> compare costs, drawdowns, and stability.

## Run tests

The CI check is intentionally **static source guardrails and Python research logic**, not a substitute for MetaEditor.

    python -m unittest discover -s tests -v

See [docs/validation.md](docs/validation.md) for actual MT5 testing instructions.

Attribution in the original source header and commit history is preserved. © 2026 BoltIQ research additions.