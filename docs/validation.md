# Strategy Tester validation | evidence-first

1. Record commit SHA, terminal build, symbol, broker, spread/commission and local vs broker time.
2. Open MetaEditor on Windows and compile `blackXAU2.mq5` and `Research/FibonacciStudy.mq5`; report warnings and errors (target zero).
3. Test new EA with `EnableTrading=false` first: expect **zero orders**. Test `AllowRealAccount=false` separately.
4. For orders, set `EnableTrading=true` on **demo/Strategy Tester only**. Verify buy-only behavior, retest after the closed breakout candle, ATR failure, session/news filter and one-position limits.
5. Check minimum volume and rejection on too-small risk budget; check daily and peak equity caps and restart behavior. Broker minimum stop level may differ by symbol.
6. Run `Every tick based on real ticks` only if the broker provides actual tick history. Record spread, slippage, costs and modeling quality.
7. Use chronological training / out-of-sample / untouched holdout. Do walk-forward tests and parameter perturbations to check overfitting.
8. Archive HTML report, expert log, input `.set`, screenshot, build version and commit SHA. Do not publish client account details.

### Test status for this revision

- MQL5 compile: **NOT VERIFIED**
- MT5 Strategy Tester: **NOT VERIFIED**
- Python/static check: automated separately; not MQL5 compilation
- Profitability/live execution: **NOT VERIFIED**

Static source testing can catch accidental removal of safety gates but cannot validate a broker order or MQL5 syntax.