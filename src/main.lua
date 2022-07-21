--[[
'FIXME', 'TODO', 'CHANGED', 'XXX', 'IDEA', 'HACK', 'NOTE', 'REVIEW', 'NB', 'BUG', 'QUESTION', 'COMBAK', 'TEMP'
]] --

--[[ REQUIRES ]]--

require "control" --game control functions
require "read_memory" --memory functions

--[[ END REQUIRES ]]--


--[[ GLOBALS ]]--

BOT_PLAYER_NUM = 1
NUM_INPUTS = 50 -- TODO
NUM_OUTPUTS = 5 -- TODO

--[[ END GLOBALS ]]--





--[[    MAIN BLOCK      ]]--

do
    --stuff--
    local settings = { "1", "A", "1", "low", "1", "on" }

    --handle args
    if arg then
        local count = 1
        for s in arg:gmatch("([^" .. ", " .. "]+)") do
            if count == 1 and s == "2" then
                -- if user said 2 players
                settings = { "2", "1", "low", "5", "high", "on" } -- default 2 player settings
                BOT_PLAYER_NUM = 2
            else
                settings[count] = s
            end
            count = count + 1
        end
    end

    emu.poweron()

    applySettings(settings)

    --which only happens AFTER all the blocks are loaded in
    while onlyHasValue(MemMap.fallingBlocks(), 0) do
        print("waiting")
        joypad.set(1, { down = true })
        emu.frameadvance()
    end
    --0x046A is some random byte that stays as 40 (28 hex) until the stun timer for falling blocks is set,
    while hasValue(readBytes(0x046A, 4), 40) do
        print("waiting again")
        emu.frameadvance()
    end
    print("starting falling blocks: " .. table.toString(MemMap.fallingBlocks()))
    print("random byte thing: " .. memory.readbyte(0x046A))

    Board:update()
    Board:copy()

    --[[    MAIN LOOP   ]]--
    while true do
        Board:update()
        --handleBlockSet()
        emu.frameadvance()
    end
end
