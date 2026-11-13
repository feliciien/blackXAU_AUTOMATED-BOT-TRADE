# MT5 Expert Advisor — Independent Execution & Risk QA Sample

**Version:** 2026-11-13 · **Publisher:** BoltIQ Markets · **Educational, fully synthetic scenario**.

> This is a **sample test plan**, not evidence that the public blackXAU EA, a customer's EA, or any live account passed the checks below. No actual MT5 Strategy Tester, broker connectivity, order submission, or account access was performed to generate this example.

## Purpose

Before trusting an Expert Advisor with demo or live execution, establish what it should do under a trading condition *and* when things go wrong. A backtest's aggregate win rate or equity curve is not proof of runtime execution safety.

**Minimum reproducibility inputs:** a versioned .mq5/.ex5 build where authorized, .set configuration, broker server and symbol specification, account type, tick model, test date range, time-zone rules, sanitised Experts/Journal logs and a written requirement. Never share passwords, tokens or account numbers.

## Small acceptance matrix (all observations hypothetical)

| Test ID | Condition / controlled setup | Expected acceptance result | Evidence needed | Actual status |
| --- | --- | --- | --- | --- |
| QA-01 | A valid signal is received while broker reports max spread above the configured cap | No new order. The filter blocks the request and logs reason, symbol, time and measured spread | Log trace + observed positions and pending-order count | **NOT RUN** |
| QA-02 | A risk budget corresponds to 0.003 lot but the broker's minimum volume is 0.01 lot | No forced minimum-lot order when that violates max monetary risk; explicit risk-sizing rejection | Symbol contract and lot-step metadata + sizing calculation + journal | **NOT RUN** |
| QA-03 | An entry request times out during disconnect and its broker status is unknown | Do not send a blind retry. Persist or reconstruct request reference; reconcile deals/orders and only resume when status is known | Synthetic request IDs, order/deal state transitions, restart journal | **NOT RUN** |
| QA-04 | Equity crosses a stated daily-loss threshold with unrealized PnL at the rule's reset boundary | According to the **contractually supplied rule**, halt all new risk; do not automatically reset in conflict with the server's specified day and open equity | Frozen reset timestamp/time zone, starting equity and unrealized PnL values, rejection traces | **NOT RUN** |
| QA-05 | A BUY-only system receives a valid short signal | Explicitly reject or ignore the short signal; no sell position is opened; document feature limits | Signal snapshot and MT5 orders/deals before/after | **NOT RUN** |

**Synthetic failure-report example for QA-03 only (illustrative, NOT an observed blackXAU defect):**

- Requirement: after a timed-out entry, unknown broker status must not trigger another entry before reconciliation.
- Injected conditions: simulated accepted-but-delayed acknowledgment, terminal restart, duplicate signal event.
- Hypothetical observation: request `R-101` has uncertain state; a second request `R-102` is generated before original order lookup completes.
- Expected outcome: request `R-102` is **blocked** pending reconciliation, with a logged hold reason.
- Report status: `NOT RUN / EXAMPLE ONLY`; if reproduced on an authorized build with real logs, classify as a potential **P1 duplicate-exposure defect** and fix before rollout.
- Remaining gaps: broker transaction-order semantics, actual execution reports, account position mode and persisted reference handling.

## Acceptance approach

1. Confirm ownership and one specific defect or release concern; record exact expected and actual behavior.
2. Freeze one EA build, configuration, symbol specification and test environment.
3. Test normal, boundary and failure paths using **permitted demo or synthetic evidence**, without any live trades.
4. Collect redacted logs, timestamps, test artifacts, observed state, and a fail/pass/not-run result for each case.
5. Clearly separate reproduced defects, plausible root causes, non-reproducible observations and items not tested.
6. Obtain written agreement before any additional implementation, integration or broad performance testing.

A technical review cannot certify profitability, zero slippage, compliance with every prop-firm rule, or future broker behavior.

## Need a scoped independent technical review?

If you have **one authorized MT5 EA version**, **one reproducible problem**, and sanitized evidence, [request the BoltIQ Markets $149 MT5 EA Execution & Risk Diagnostic](https://boltiqmarkets.com/services/mt5-engineering#diagnostic).

The stated fee is indicative until written scope and acceptance. The inquiry does not charge or request credentials. This link is offered for direct projects originating from this public repository; do not use it to circumvent MQL5 Freelance, Upwork, Fiverr or other marketplace contracting rules.

---

**Provenance:** authored for public technical education by BoltIQ Markets. Synthetic examples are illustrative and are not third-party client results.
