//+------------------------------------------------------------------+
//| FibonacciStudy.mq5                                               |
//| Original research demonstration; NO orders are ever submitted.   |
//| Latest confirmed pivots and closed-bar retracement signals.      |
//+------------------------------------------------------------------+
#property copyright "2026 BoltIQ Research"
#property version "1.00"
#property strict
input ENUM_TIMEFRAMES InpStructureTF=PERIOD_H1;
input ENUM_TIMEFRAMES InpSignalTF=PERIOD_M15;
input int InpSwingStrength=3;
input int InpLookback=120;
input double InpShallow=0.500;
input double InpDeep=0.618;
input bool InpAllowShort=false;
datetime lastClosed=0;
bool PivotHigh(const MqlRates &r[],int i,int n,int span)
{
   if(i<span || i+span>=n)return false;
   for(int k=1;k<=span;k++)
      if(r[i].high<=r[i-k].high || r[i].high<=r[i+k].high)return false;
   return true;
}
bool PivotLow(const MqlRates &r[],int i,int n,int span)
{
   if(i<span || i+span>=n)return false;
   for(int k=1;k<=span;k++)
      if(r[i].low>=r[i-k].low || r[i].low>=r[i+k].low)return false;
   return true;
}
int OnInit()
{
   if(InpSwingStrength<1 || InpLookback<2*InpSwingStrength+12 ||
      InpShallow<=0 || InpDeep>=1 || InpShallow>=InpDeep)
      return INIT_PARAMETERS_INCORRECT;
   lastClosed=iTime(_Symbol,InpSignalTF,1);
   Print("Fib study: SIGNALS ONLY. No trade functions are present.");
   return INIT_SUCCEEDED;
}
void OnTick()
{
   datetime closed=iTime(_Symbol,InpSignalTF,1);
   if(closed<=0 || closed==lastClosed)return;
   lastClosed=closed;
   MqlRates bars[];
   ArraySetAsSeries(bars,true);
   int n=CopyRates(_Symbol,InpStructureTF,1,InpLookback,bars);
   if(n<2*InpSwingStrength+12)return;
   int hi=-1,lo=-1;
   for(int i=InpSwingStrength;i<n-InpSwingStrength;i++)
   {
      if(hi<0 && PivotHigh(bars,i,n,InpSwingStrength))hi=i;
      if(lo<0 && PivotLow(bars,i,n,InpSwingStrength))lo=i;
      if(hi>=0 && lo>=0)break;
   }
   if(hi<0 || lo<0 || hi==lo)return;
   double high=bars[hi].high, low=bars[lo].low;
   if(high<=low)return;
   MqlRates signal[];
   ArraySetAsSeries(signal,true);
   if(CopyRates(_Symbol,InpSignalTF,1,1,signal)!=1)return;
   double range=high-low;
   if(hi<lo)
   {
      double upper=high-InpShallow*range;
      double lower=high-InpDeep*range;
      if(signal[0].low<=upper && signal[0].high>=lower &&
         signal[0].close>upper && signal[0].close>signal[0].open)
         PrintFormat("RESEARCH BUY | %s | fib band %.5f .. %.5f | invalidation %.5f",
                     _Symbol,lower,upper,low);
   }
   else if(InpAllowShort)
   {
      double lower=low+InpShallow*range;
      double upper=low+InpDeep*range;
      if(signal[0].high>=lower && signal[0].low<=upper &&
         signal[0].close<lower && signal[0].close<signal[0].open)
         PrintFormat("RESEARCH SELL | %s | fib band %.5f .. %.5f | invalidation %.5f",
                     _Symbol,lower,upper,high);
   }
}
