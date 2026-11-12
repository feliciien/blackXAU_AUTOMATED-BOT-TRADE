"""Reference-only safety invariants. Not MetaEditor or MT5 tests."""
import math
import pathlib
import unittest

ROOT=pathlib.Path(__file__).resolve().parents[1]
EA=(ROOT/"blackXAU2.mq5").read_text(encoding="utf-8")
FIB=(ROOT/"Research/FibonacciStudy.mq5").read_text(encoding="utf-8")

def scaled_volume(risk, minimum, maximum, step, min_loss):
    if min(risk, minimum, maximum, step, min_loss)<=0:
        return 0
    raw=minimum*risk/min_loss
    if raw<minimum:
        return 0
    volume=minimum+math.floor((min(raw,maximum)-minimum+1e-10)/step)*step
    return round(volume,8) if volume*min_loss/minimum<=risk+0.01 else 0

class ResearchChecks(unittest.TestCase):
    def test_live_execution_off(self):
        self.assertIn("EnableTrading      = false",EA)
        self.assertIn("AllowRealAccount   = false",EA)
    def test_broker_sizing(self):
        self.assertIn("OrderCalcProfit",EA)
        self.assertIn("raw<minVol",EA)
    def test_risk_floor_and_broker_confirmation(self):
        self.assertIn("RiskFloorAllows",EA)
        self.assertIn("ResultRetcode()",EA)
        self.assertIn("ResultDeal()",EA)
    def test_closed_bar_fib(self):
        self.assertIn("CopyRates(_Symbol,InpStructureTF,1,InpLookback,bars)",FIB)
        self.assertIn("CopyRates(_Symbol,InpSignalTF,1,1,signal)",FIB)
        self.assertNotIn("trade.Buy(",FIB)
        self.assertNotIn("trade.Sell(",FIB)
    def test_volume_below_broker_min(self):
        self.assertEqual(scaled_volume(4,.01,2,.01,10),0)
    def test_volume_rounded_down(self):
        self.assertEqual(scaled_volume(105,.01,2,.01,10),.1)
    def test_volume_bounded(self):
        self.assertEqual(scaled_volume(100000,.01,.11,.01,10),.11)

if __name__=="__main__":
    unittest.main()
