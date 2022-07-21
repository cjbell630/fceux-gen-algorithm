do
local _ENV=_ENV
package.preload["control"]=function(...)local e=_G.arg;function putMarioAtPos(e)print("mario needs to move from "..MemMap.marioPos().." to "..e)if MemMap.marioPos()>e then
while MemMap.marioPos()~=e do
print("moving left")joypad.set(BOT_PLAYER_NUM,{left=true})emu.frameadvance()joypad.set(BOT_PLAYER_NUM,{left=false})emu.frameadvance()end
elseif MemMap.marioPos()<e then
while MemMap.marioPos()~=e do
joypad.set(BOT_PLAYER_NUM,{right=true})emu.frameadvance()joypad.set(BOT_PLAYER_NUM,{right=false})emu.frameadvance()end
end
print("moved successfully")end
function swapAtPos(e)putMarioAtPos(e)local e=MemMap.marioFrame()local n=e==0 and 4 or 0
while MemMap.marioFrame()==e do
joypad.set(BOT_PLAYER_NUM,{A=true})emu.frameadvance()joypad.set(BOT_PLAYER_NUM,{A=false})emu.frameadvance()end
while MemMap.marioFrame()~=n do
joypad.set(BOT_PLAYER_NUM,{A=false})emu.frameadvance()end
end
function swapAtAllPosInTable(e)if#e>0 then
print("swapping at "..table.toString(e))for n,e in ipairs(e)do
swapAtPos(e)end
end
return states
end
function moveColumn(n,e)if n>0 then
print("need to move column "..n.." to position "..e)local e=e-n
local a=e/math.abs(e)print("iterating from 0 to "..math.abs(e))if e~=0 then
for e=0,math.abs(e)-1 do
swapAtPos(n+(e*a)+((a-3)/2))end
end
end
end
function randomPause(e)e=e or 5
for e=0,math.random(e)do
emu.frameadvance()end
end
function applySettings(a)local e=tonumber(a[1])if e==1 and tonumber(a[5])~=nil then
local e={"mushroom","flower","star","off"}a[5]=e[tonumber(a[5])]end
local t=a[6]=="on"math.randomseed(os.time())while MemMap.startMenuSelectorStatus()~=1 do
emu.frameadvance()end
while MemMap.startMenuSelectorStatus()~=e do
joypad.set(1,{down=true})emu.frameadvance()emu.frameadvance()end
joypad.set(1,{start=true})emu.frameadvance()while MemMap.settingsMenuSelectorStatus()do
emu.frameadvance()end
if t then
randomPause()end
local n=e==1 and{MemMap.menuSettGame,MemMap.menuSettLevel,MemMap.menuSettSpeed,MemMap.menuSettBGM}or{MemMap.menuSettLevel,MemMap.menuSettSpeed}for r,d in ipairs(n)do
for n=1,e do
local o=MemMap.menuSettName(e==1 and 0 or n)while tostring(d(e==1 and 0 or n))~=a[(e==1 and r+1 or(2*n+r-1))]do
joypad.set(n,{right=true})emu.frameadvance()emu.frameadvance()end
if t then
randomPause()end
if o~=(e==1 and"bgm"or"speed")then
while MemMap.menuSettName(e==1 and 0 or n)==o do
joypad.set(n,{down=true})emu.frameadvance()emu.frameadvance()end
end
print("[set "..(e==1 and" "or("player "..n.."'s "))..o.." to "..a[(e==1 and r+1 or(2*n+r-1))].."]")end
end
joypad.set(1,{start=true})emu.frameadvance()end
function dropUntilNumBlocksFalling(e)while e<MemMap.numFallingBlocks()do
joypad.set(BOT_PLAYER_NUM,{down=true})emu.frameadvance()end
end
end
end
do
local _ENV=_ENV
package.preload["read_memory"]=function(...)local e=_G.arg;require"util"Blocks={NONE=0,GOOMBA=1,PIRANHA=2,BOO=3,BLOOPER=4,TOP_EGG=5,BOTTOM_EGG=6}function readBytes(a,n)local e={}for n=0,n-1 do
e[n+1]=memory.readbyte(a+n)end
return e
end
function readColumn(n)return map({1,2,3,4,5,6,7,8},function(e)return memory.readbyte(1168+(e-1)+((n-1)*9))end)end
MemMap={addresses={MENU_PLAYERS=227,SETT_MENU_CURSOR_STAT=609,OP_MENU_SETT_ROW=758,OP_MENU_GAME=660,OP_MENU_LEVEL=661,OP_MENU_SPEED=662,OP_MENU_BGM=663,TP_MENU_P1_SETT_ROW=1349,TP_MENU_P2_SETT_ROW=1350,TP_MENU_P1_LEVEL=660,TP_MENU_P1_SPEED=661,TP_MENU_P2_LEVEL=662,TP_MENU_P2_SPEED=663,MARIO_POS=1088,LUIGI_POS=1089,MARIO_FRAME=1090,LUIGI_FRAME=1091,P1_FALL_TYPES_START=1114,P2_FALL_TYPES_START=1118,P1_FALL_STATUS_START=1122,P2_FALL_STATUS_START=1126,P1_BOARD_START=1168,P2_BOARD_START=1204}}function MemMap.marioPos(e)e=e or BOT_PLAYER_NUM
return memory.readbyte(MemMap.addresses[(e==2 and"LUIGI"or"MARIO").."_POS"])end
function MemMap.marioFrame(e)e=e or BOT_PLAYER_NUM
return memory.readbyte(MemMap.addresses[(e==2 and"LUIGI"or"MARIO").."_FRAME"])end
function MemMap.fallingBlocks(e)e=e or BOT_PLAYER_NUM
return readBytes(MemMap.addresses[(e==2 and"P2"or"P1").."_FALL_TYPES_START"],4)end
function MemMap.numFallingBlocks()pNum=pNum or BOT_PLAYER_NUM
return instancesOf(readBytes(MemMap.addresses[(pNum==2 and"P2"or"P1").."_FALL_STATUS_START"],4),2)end
function MemMap.column(n,e)e=e or BOT_PLAYER_NUM
return readBytes(MemMap.addresses[(e==2 and"P2"or"P1").."_BOARD_START"]+((n-1)*9),8)end
function MemMap.startMenuSelectorStatus()local e={[199]=1,[215]=2}return e[memory.readbyte(MemMap.addresses.MENU_PLAYERS)]end
function MemMap.settingsMenuSelectorStatus(e)e=e or 0
return memory.readbyte(MemMap.addresses.SETT_MENU_CURSOR_STAT)==(e>0 and 176 or 204)end
function MemMap.menuSettName(e)e=e or 0
local n=e==0 and{"game","level","speed","bgm"}or{"level","speed"}return n[memory.readbyte(MemMap.addresses[e==1 and"TP_MENU_P1_SETT_ROW"or e==2 and"TP_MENU_P2_SETT_ROW"or"OP_MENU_SETT_ROW"])+1]end
function MemMap.menuSettGame()local e={[104]="A",[160]="B"}return e[memory.readbyte(MemMap.addresses.OP_MENU_GAME)]end
function MemMap.menuSettLevel(e)e=e or 0
local n={[96]=1,[120]=2,[144]=3,[168]=4,[192]=5}return n[memory.readbyte(MemMap.addresses[e==1 and"TP_MENU_P1_LEVEL"or e==2 and"TP_MENU_P2_LEVEL"or"OP_MENU_LEVEL"])]end
function MemMap.menuSettSpeed(e)e=e or 0
local n={[100]="low",[160]="high"}return n[memory.readbyte(MemMap.addresses[e==1 and"TP_MENU_P1_SPEED"or e==2 and"TP_MENU_P2_SPEED"or"OP_MENU_SPEED"])]end
function MemMap.menuSettBGM()local e={[72]="mushroom",[104]="flower",[136]="star",[168]="off"}return e[memory.readbyte(MemMap.addresses.OP_MENU_BGM)]end
Board={raw={{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0}}}function Board:getRow(e)return{}end
function Board:update(e)e=e or BOT_PLAYER_NUM
self.raw=map({1,2,3,4},function(n)return MemMap.column(n,e)end)end
function Board:getTopBlocks()return map(self.raw,function(e)for n,e in ipairs(e)do
if e>0 then
return e
end
end
return 0
end)end
function Board:matchesOnTops(n)return map(self:getTopBlocks(),function(e)return e==n
end)end
function Board:numBlocksInCol(e)for n,e in ipairs(self.raw[e])do
if e>0 then
return 9-n
end
end
return 0
end
function Board:copy()return copy(self)end
end
end
do
local _ENV=_ENV
package.preload["util"]=function(...)local e=_G.arg;function concatTables(e,n)for a,n in ipairs(n)do
e[#e+1]=n
end
return e
end
function table.toString(n)if n then
local e=""for a,n in ipairs(n)do
e=e..(type(n)=="table"and table.toString(n)or n)..", "end
return string.sub(e,1,#e-2)else
return""end
end
function hasValue(e,n)for a,e in pairs(e)do
if e==n then
return true
end
end
return false
end
function onlyHasValue(e,n)for a,e in pairs(e)do
if not(e==n)then
return false
end
end
return true
end
function instancesOf(n,e)inst=0
for a,n in pairs(n)do
if n==e then
inst=inst+1
end
end
return inst
end
function firstIndexOf(e,n)for e,a in ipairs(e)do
if a==n then
return e
end
end
return 0
end
function tablesEqualOrder(a,r,n)for e=1,#a do
if not(a[e]==r[e]or(n~=nil and(a[e]==n or r[e]==n)))then
return false
end
end
return true
end
function areConsecutiveNums(e,n)return(e+1==n)or(n+1==e)end
function swapTableSubTabs(e,a,n)local r=e[a]e[a]=e[n]e[n]=r
return e
end
function map(n,r)local e={}for a,n in ipairs(n)do
e[a]=r(n)end
return e
end
function copy(e)local n={}for a,e in pairs(e)do
n[a]=type(e)=="table"and copy(e)or e
end
return n
end
function replace(e,r,a)for o,n in ipairs(e)do
if n==r then
e[o]=a
end
end
return e
end
function tableToInvertedDict(n)local e={}for a,n in ipairs(n)do
e[n]=e[n]==nil and 1 or e[n]+1
end
return e
end
end
end
require"control"require"read_memory"BOT_PLAYER_NUM=1
do
local n={"1","A","1","low","1","on"}if arg then
local e=1
for a in arg:gmatch("([^"..", ".."]+)")do
if e==1 and a=="2"then
n={"2","1","low","5","high","on"}BOT_PLAYER_NUM=2
else
n[e]=a
end
e=e+1
end
end
emu.poweron()applySettings(n)while onlyHasValue(MemMap.fallingBlocks(),0)do
print("waiting")joypad.set(1,{down=true})emu.frameadvance()end
while hasValue(readBytes(1130,4),40)do
print("waiting again")emu.frameadvance()end
print("starting falling blocks: "..table.toString(MemMap.fallingBlocks()))print("random byte thing: "..memory.readbyte(1130))Board:update()Board:copy()while true do
Board:update()emu.frameadvance()end
end