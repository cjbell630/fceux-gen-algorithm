--[[ REQUIRES ]]--

require "util"

--[[ END REQUIRES ]]--


--NOTE memory notes from main.lua
-- overwrites to 0 when landing, overwrites to new pair when both landed
--TODO: 051E restarts the screen??? investigate
--0E60 is weird
--12F0
--NOTE: 0300 is 00 when not moving, 23 when moving
--NOTE: 0440 stores swap position (0, 1, 2)
--NOTE: 0442 stores orientation. 0 or 4 when not turning
--NOTE: 0462, 0463, 0464, 0465 are 1 when about to fall, 0 when empty, and 2 when falling

Blocks = {
    NONE = 0,
    GOOMBA = 1,
    PIRANHA = 2,
    BOO = 3,
    BLOOPER = 4,
    TOP_EGG = 5,
    BOTTOM_EGG = 6
}

--TODO: should be local when I move that timer thingy to here
function readBytes(address, length)
    local bytes = {}
    for i = 0, length - 1 do
        bytes[i + 1] = memory.readbyte(address + i)
    end
    return bytes
end


--TODO: doc
function readColumn(columnNumber)
    return map({ 1, 2, 3, 4, 5, 6, 7, 8 }, function(i)
        return memory.readbyte(0x0490 + (i - 1) + ((columnNumber - 1) * 9))
    end)
    --[[
    local columnTable = {}
    for i = 1, 8 do
        columnTable[i] = memory.readbyte(0x0490 + (i - 1) + ((columnNumber - 1) * 9))
    end
    return columnTable]]--
end


--MEMMAP CLASS--

--MemMap = {}
--MemMap.__index = MemMap

--[[

╔═════════════════╦═════════════════════╦═══════════════════════════════════════════════════════════════════════════════════════════════════════╗
║     address     ║        length       ║                                              explanation                                              ║
╠═════════════════╬═════════════════════╬═══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ 0x0440          ║ 1 byte              ║ Represents mario's current position                                                                   ║
║                 ║                     ║ 0, 1, or 2   ----   l -> r                                                                            ║
╠═════════════════╬═════════════════════╬═══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ 0x0442          ║ 1 byte              ║ Represent's Mario's current animation frame.                                                          ║
║                 ║                     ║ Cycles through whenever he turns, remains constant otherwise                                          ║
║                 ║                     ║                                                                                                       ║
║                 ║                     ║ 0 - forward                                                                                           ║
║                 ║                     ║ 1/2/3 - turning                                                                                       ║
║                 ║                     ║ 4 - backward                                                                                          ║
╠═════════════════╬═════════════════════╬═══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ 0x045A          ║ 1 byte each         ║ Stores information about what types of blocks are currently falling                                   ║
║ 0x045B          ║                     ║ (xxxA -> xxxD | l -> r column)                                                                        ║
║ 0x045C          ║                     ║ Values are set the frame where the last group are set (which is one "tick" before they start falling) ║
║ 0x045D          ║                     ║ Value is cleared when the block they represent is set/matched                                         ║
║                 ║                     ║                                                                                                       ║
║                 ║                     ║ 0 - empty                                                                                             ║
║                 ║                     ║ 1 - Goomba                                                                                            ║
║                 ║                     ║ 2 - Piranha Plant                                                                                     ║
║                 ║                     ║ 3 - Boo                                                                                               ║
║                 ║                     ║ 4 - Blooper                                                                                           ║
║                 ║                     ║ 5 - Top Egg                                                                                           ║
║                 ║                     ║ 6 - Bottom Egg                                                                                        ║
╠═════════════════╬═════════════════════╬═══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ 0x0462          ║ 1 byte each         ║ Stores information about blocks falling status                                                        ║
║ 0x0463          ║                     ║ (xxx2 -> xxx5 | l -> r column)                                                                        ║
║ 0x0464          ║                     ║                                                                                                       ║
║ 0x0465          ║                     ║ 0 - no block falling (ie moving, so set to 0 when block stops moving)                                 ║
║                 ║                     ║ 1 - block in column, blocks are stunned (delay between setting prev blocks and dropping new ones)     ║
║                 ║                     ║ 2 - block falling in column                                                                           ║
╠═════════════════╬═════════════════════╬═══════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ 0x0490 - 0x0497 ║ 1 byte each address ║ Stores the currently displayed blocks on the board                                                    ║
║ 0x0499 - 0x04A0 ║                     ║ 0x0490 -> 0x0497 = top -> bottom                                                                      ║
║ 0x04A2 - 0x04A9 ║                     ║ 0x0490 -> 0x04AB = left -> right                                                                      ║
║ 0x04AB - 0x04B2 ║                     ║ Stores the positions from top to bottom, with a 1 byte buffer between each column.                    ║
║                 ║                     ║ Positions only include set pieces (so NOT ones that have 2 for their respective above address)        ║
║                 ║                     ║ Uses same values as falling block addresses                                                           ║
╚═════════════════╩═════════════════════╩═══════════════════════════════════════════════════════════════════════════════════════════════════════╝


]]--
MemMap = {
    addresses = {
        MENU_PLAYERS = 0x00E3, --TODO rename
        SETT_MENU_CURSOR_STAT = 0x0261,

        --[[1P (OnePlayer) settings menu addresses]]--
        OP_MENU_SETT_ROW = 0x02F6,
        OP_MENU_GAME = 0x0294,
        OP_MENU_LEVEL = 0x0295,
        OP_MENU_SPEED = 0x0296,
        OP_MENU_BGM = 0x0297,

        --[[2P (TwoPlayer) settings menu addresses]]--
        TP_MENU_P1_SETT_ROW = 0x0545,
        TP_MENU_P2_SETT_ROW = 0x0546,
        TP_MENU_P1_LEVEL = 0x0294,
        TP_MENU_P1_SPEED = 0x0295,
        TP_MENU_P2_LEVEL = 0x0296,
        TP_MENU_P2_SPEED = 0x0297,

        MARIO_POS = 0x0440,
        LUIGI_POS = 0x0441,
        MARIO_FRAME = 0x0442,
        LUIGI_FRAME = 0x0443,
        P1_FALL_TYPES_START = 0x045A,
        P2_FALL_TYPES_START = 0x045E,
        P1_FALL_STATUS_START = 0x0462,
        P2_FALL_STATUS_START = 0x0466,

        P1_BOARD_START = 0x0490,
        P2_BOARD_START = 0x04B4
    }
}
--MemMap.

function MemMap.marioPos(pNum)
    pNum = pNum or BOT_PLAYER_NUM
    return memory.readbyte(MemMap.addresses[(pNum == 2 and "LUIGI" or "MARIO") .. "_POS"])
end

function MemMap.marioFrame(pNum)
    pNum = pNum or BOT_PLAYER_NUM
    return memory.readbyte(MemMap.addresses[(pNum == 2 and "LUIGI" or "MARIO") .. "_FRAME"])
end

function MemMap.fallingBlocks(pNum)
    pNum = pNum or BOT_PLAYER_NUM
    return readBytes(MemMap.addresses[(pNum == 2 and "P2" or "P1") .. "_FALL_TYPES_START"], 4)
end

function MemMap.numFallingBlocks()
    pNum = pNum or BOT_PLAYER_NUM
    return instancesOf(readBytes(MemMap.addresses[(pNum == 2 and "P2" or "P1") .. "_FALL_STATUS_START"], 4), 2)
end

function MemMap.column(colNum, pNum)
    pNum = pNum or BOT_PLAYER_NUM
    return readBytes(MemMap.addresses[(pNum == 2 and "P2" or "P1") .. "_BOARD_START"] + ((colNum - 1) * 9), 8)
end

-- gets the status of the start menu egg cursor
-- return values: nil=other, 1=1PLAYER, 2=2PLAYER
--TODO doc
function MemMap.startMenuSelectorStatus()
    local values = { [0xC7] = 1, [0xD7] = 2 }
    return values[memory.readbyte(MemMap.addresses.MENU_PLAYERS)]
end

-- gets the status of the start menu egg cursor
-- return values: false=off, true=on
--TODO doc
--TODO can prob extrapolate more from this
function MemMap.settingsMenuSelectorStatus(pNum)
    pNum = pNum or 0
    return memory.readbyte(MemMap.addresses.SETT_MENU_CURSOR_STAT) == (pNum > 0 and 0xB0 or 0xCC)
end

-- gets the status of the start menu egg cursor
-- return values: nil=other, game=GAME, level=LEVEL, speed=SPEED, bgm=BGM
--TODO doc
function MemMap.menuSettName(pNum)
    pNum = pNum or 0
    local values = pNum == 0 and { "game", "level", "speed", "bgm" } or { "level", "speed" }
    return values[memory.readbyte(MemMap.addresses[pNum == 1 and "TP_MENU_P1_SETT_ROW" or pNum == 2 and "TP_MENU_P2_SETT_ROW" or "OP_MENU_SETT_ROW"]) + 1]
end

-- gets the current selection of the game setting on the menu
-- return values: nil=other, A=A TYPE, B=B TYPE
--TODO doc
function MemMap.menuSettGame()
    local values = { [0x68] = "A", [0xA0] = "B" }
    return values[memory.readbyte(MemMap.addresses.OP_MENU_GAME)]
end

-- gets the current selection of the level setting on the menu
-- return values: nil=other, 1,2,3,4,5=that number level
-- could do with divison, as each one is 0x18 apart, but keeping it this way for speed
--TODO doc
function MemMap.menuSettLevel(pNum)
    pNum = pNum or 0
    local values = { [0x60] = 1, [0x78] = 2, [0x90] = 3, [0xA8] = 4, [0xC0] = 5 }
    return values[memory.readbyte(MemMap.addresses[pNum == 1 and "TP_MENU_P1_LEVEL" or pNum == 2 and "TP_MENU_P2_LEVEL" or "OP_MENU_LEVEL"])]
end

-- gets the current selection of the level setting on the menu
-- return values: nil=other, low=LOW, high=HIGH
--TODO doc
function MemMap.menuSettSpeed(pNum)
    pNum = pNum or 0
    local values = { [0x64] = "low", [0xA0] = "high" }
    return values[memory.readbyte(MemMap.addresses[pNum == 1 and "TP_MENU_P1_SPEED" or pNum == 2 and "TP_MENU_P2_SPEED" or "OP_MENU_SPEED"])]
end

-- gets the current selection of the level setting on the menu
-- return values: nil=other, mushroom=mushroom icon, etc, off=OFF
-- could do with divison, as each one is 0x20 apart, but keeping it this way for speed
--TODO doc
function MemMap.menuSettBGM()
    local values = { [0x48] = "mushroom", [0x68] = "flower", [0x88] = "star", [0xA8] = "off" }
    return values[memory.readbyte(MemMap.addresses.OP_MENU_BGM)]
end


--END MEMMAP CLASS--

--BOARD ClASS--

Board = {
    raw = {
        --[[top   ->  bottom]] --
        { 0, 0, 0, 0, 0, 0, 0, 0 }, -- right
        { 0, 0, 0, 0, 0, 0, 0, 0 }, --   ^
        { 0, 0, 0, 0, 0, 0, 0, 0 }, --   |
        { 0, 0, 0, 0, 0, 0, 0, 0 }  -- left
    }
}

--TODO: this
function Board:getRow(rowNum)
    return {
        --Board.raw[1],
    }
end

--stores every block in the 2d table "board"
--NOTE: 8 per row
--NOTE: 2 byte spacing, figure out what they do
--NOTE: reads properly, but doesn't reload sprites.
--NOTE: Reloads for matches!! ex can force any two blocks to match by rewriting 😈
--NOTE: 0490-0497 controls column 1 top-bottom
--NOTE: 0499-04A0 controls column 2
--NOTE: 04A2-04A9 controls column 3
--NOTE: 04AB-04B2 controls column 4
function Board:update(pNum)
    pNum = pNum or BOT_PLAYER_NUM
    self.raw = map({ 1, 2, 3, 4 }, function(c)
        return MemMap.column(c, pNum)
    end)
    --[[for i = 1, 4 do
        board[i] = getColumn(i)
    end]]--
end

--TODO doc
function Board:getTopBlocks()
    return map(self.raw, function(col)
        for _, block in ipairs(col) do
            if block > 0 then
                return block
            end
        end
        return 0
    end)

    --[[local tops = { 0, 0, 0, 0 }
    for colNum, col in ipairs(Board.raw) do
        for rowNum, block in ipairs(col) do
            if block > 0 then
                tops[colNum] = block
                break
            end
        end
    end
    return tops]]--
end

--TODO doc
function Board:matchesOnTops(block)
    --TODO: could be getTops -> map i==block
    --return { getTopBlock(board[1]) == block, getTopBlock(board[2]) == block, getTopBlock(board[3]) == block, getTopBlock(board[4]) == block }
    return map(
            self:getTopBlocks(), function(v)
                return v == block
            end
    )
end

--TODO doc
function Board:numBlocksInCol(colNum)
    --TODO REMOVE print("numBlocksInCol debug: num: "..colNum.."       table: "..table.toString(self.raw))
    for i, v in ipairs(self.raw[colNum]) do
        if v > 0 then
            return 9 - i
        end
    end
    return 0
end

function Board:copy()
    --local new = copy(self)
    --[[print("self raw "..table.toString(self.raw))
    print("new raw "..table.toString(new.raw))
    new.raw[1][1] = 69
    print("self raw "..table.toString(self.raw))
    print("new raw "..table.toString(new.raw))
    print("self top "..table.toString(self:getTopBlocks()))
    print("new top "..table.toString(new:getTopBlocks()))]]--
    return copy(self)
end

--END BOARD CLASS--



--[[ UNUSED ]]--

--[[
--stores every block in the 2d table "board"
--NOTE: 8 per row
--NOTE: 2 byte spacing, figure out what they do
--NOTE: reads properly, but doesn't reload sprites.
--NOTE: Reloads for matches!! ex can force any two blocks to match by rewriting 😈
--NOTE: 0490-0497 controls column 1 top-bottom
--NOTE: 0499-04A0 controls column 2
--NOTE: 04A2-04A9 controls column 3
--NOTE: 04AB-04B2 controls column 4
function readBoard()
    board = map({ 1, 2, 3, 4 }, readColumn)
end


--gets the amount of blocks in a column (table) that are not empty
function getColumnSize(column)
    for i, v in ipairs(column) do
        if v > 0 then
            return 9 - i
        end
    end
    return 0
end


--gets the first block in a column (table) that is not empty, starting from the top
--TODO: make all these functions just get the column themselves since i never do anything else
function getTopBlock(column)
    for _, v in ipairs(column) do
        if v > 0 then
            return v
        end
    end
    return 0
end



function doColumnsHaveMatch(block)
    --TODO: could be getTops -> map i==block
    --return { getTopBlock(board[1]) == block, getTopBlock(board[2]) == block, getTopBlock(board[3]) == block, getTopBlock(board[4]) == block }
    return map(
            map(board, getTopBlock), function(v)
                return v == block
            end
    )
end



board = {
    { 0, 0, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0 }
}]]--