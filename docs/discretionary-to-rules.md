# Discretionary strategy automation | practical specifications

Every discretionary setup needs a consistent testable definition. For Fibonacci: define swing anchors, whether pivots require 2/3/5 right-side bars, wick-vs-close invalidations, redraw behavior, zone tolerance, news/session exclusions, entry expiry, slippage, and exit decisions.

### Candidate feasibility

| Setup | Required inputs | Deterministic? | Typical blocker |
|---|---|---|---|
| Swing Fibonacci retrace | Pivot strength, fib band, close rule | Often | Ambiguous anchor selection |
| Breakout/retest | Reference range, breakout close, retest window | Usually | False breakout, lookahead |
| Liquidity sweep | Equal-high tolerance, sweep wick, close reclaim | With definition | Human visual judgment |
| HTF bias | Structure breaks, pivots, timeframe | With definition | Non-stationary context |

### Development sequence

1. Ask for 10+ annotated positives and negatives of the first setup.
2. Write a decision table, invalidations and exceptions; have client sign off on objective rules.
3. Implement first prototype, compile, record tests and instrument-specific assumptions.
4. Compare test and walk-forward metrics; decide implement, revise, or reject.
5. Document each candidate and deliver source, tester files, known limitations and handover.

An engagement can evaluate as many candidates as available research hours permit, but cannot responsibly guarantee a fixed number of profitable EAs. Never claim backtests show edge without an untouched holdout and trading-cost assumptions.