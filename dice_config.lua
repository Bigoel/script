--[============================================================[

  `RW`  = Read-Write (editable) variable
  `RO`  = Read-Only variable
  `>>>` = Example usage

**** variables

  ** Stake
      apikey             : string : RW  [required]

      mirror             : string : RW  [optional]
      user_agent         : string : RW  [optional]

  basebet            : float  : RW  [required]
  currency           : string : RW  [required]
  nextbet            : float  : RW  [required]
  chance             :        : RW  [required]
                    ** float (single chance),
                       >>> chance = 37.89
                    ** table (random chance between low-high),
                       >>> chance = {low = 3.78, high = 37.8}
                    ** or, you can retrieve them using
                       dot (.) notation.
                       >>> chance.low
                       >>> chance.high

  bethigh            : bool   : RW  [optional, default: false]
  maxbet             : float  : RW  [optional]
  replay             : bool   : RW  [optional, default: false]
  resetIfLose        : float  : RW  [optional]
  resetIfProfit      : float  : RW  [optional]
  resetIfLoseStreak  : int    : RW  [optional]
  resetIfWinStreak   : int    : RW  [optional]
  targetBalance      : float  : RW  [optional]
  targetLose         : float  : RW  [optional]
  targetProfit       : float  : RW  [optional]

  balance            : float  : RO
  bets               : int    : RO
  broker             : string : RO : broker-name
  currentstreak      : int    : RO
                    ** currentstreak is a positive or negative integer.
                       Will be positive when you `win`
                       and negative when you `lose`.

  lastBet            : table  : RO
                    ** lastBet have 3 object;
                       ** gain     : float  : dirty profit from last bet (not total)
                       ** result   : float  : roll result
                       ** target   : float  : roll target
                    ** you can retrieve them using
                       dot (.) notation.
                       >>> lastBet.result

  losses             : int    : RO
  previousbet        : float  : RO
  profit             : float  : RO
  win                : bool   : RO
  wins               : int    : RO

  isFirstGreen              : bool : RO
  isFirstRed                : bool : RO
  isMaxBetReached           : bool : RO
  isResetWinStreakReached   : bool : RO
  isResetLoseStreakReached  : bool : RO
  isResetProfitReached      : bool : RO
  isResetLossReached        : bool : RO


**** functions

  dobet()              : your logic here
  stop()               : kill the bot
  resetseed()          : rotate seed

             ** resetseed require `seed` parameter,
                if seed is not specified, the bot will automatically
                generate a random seed for you.


--]============================================================]

--[=============[
     EXAMPLE!!
--]=============]



-- required variables
apikey = "xxxxxx"
currency = "ltc"
mirror = "stake.kim"



--Premmium SC Shot--

minC1      = 78
maxC1      = 93 
minC2      = 5
maxC2      = 35
chance     = math.random(minC2*100.0, maxC2*100.0)/100.0

bone       = 0.01
btwo       = 0.01
multiplier = 1.06
if_win     = 1.106085
base       = 0.0003    --Bet
nextbet    = 0.0003    --BET Samain aja kayak base
bethigh    = false
rollcount  = 7
if_profit  = balance*1e-6  --reset to base after profit
profit1    = 0
wincount   = 0
stopprofit = 50 ---Stop Profit 
balmax     = balance + stopprofit

function dobet()

   --Randomizer

   r=math.random(2)

   if r == 1 then
      bethigh=true
   else
      bethigh=false
   end

   --Randomly select High/Low

   --bethigh = math.random(0,100)%2 == 0

   --change seed every 7 bet

   if rollcount == 7 then
      rollcount = 0
      resetseed();
   else
      rollcount = rollcount + 1
   end

   --bet progression
   

   if win then
      chance = math.random(minC2*100.0, maxC2*100.0)/100.0
      nextbet = previousbet * if_win
   else
      chance = math.random(minC1*100.0, maxC1*100.0)/100.0
      nextbet = previousbet * multiplier
   end
  
    if win then
        wincount=wincount + 1
        if (profit > (profit1 + if_profit)) then
            wincount = 0
            profit1 = profit
            nextbet  = base
        end

   if balance > balmax then stop() end

   end
end
