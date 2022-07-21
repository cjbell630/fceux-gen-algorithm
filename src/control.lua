--TODO doc
function putMarioAtPos(pos)
    print("mario needs to move from " .. MemMap.marioPos() .. " to " .. pos)
    if MemMap.marioPos() > pos then
        while MemMap.marioPos() ~= pos do
            print("moving left")
            joypad.set(BOT_PLAYER_NUM, { left = true })
            emu.frameadvance()
            joypad.set(BOT_PLAYER_NUM, { left = false })
            emu.frameadvance()
        end
    elseif MemMap.marioPos() < pos then
        while MemMap.marioPos() ~= pos do
            joypad.set(BOT_PLAYER_NUM, { right = true })
            emu.frameadvance()
            joypad.set(BOT_PLAYER_NUM, { right = false })
            emu.frameadvance()
        end
    end
    print("moved successfully")
end

--TODO doc
function swapAtPos(pos)
    putMarioAtPos(pos)
    local startingFrame = MemMap.marioFrame()
    local endingFrame = startingFrame == 0 and 4 or 0
    --TODO: remove print("going to hold A until mario orientation is not "..targetOrientation)
    --TODO: remove print("mario orientation started at "..originalOrientation)
    while MemMap.marioFrame() == startingFrame do
        joypad.set(BOT_PLAYER_NUM, { A = true })
        emu.frameadvance()
        joypad.set(BOT_PLAYER_NUM, { A = false })
        emu.frameadvance()
    end
    while MemMap.marioFrame() ~= endingFrame do
        -- NOTE: says NOT EQUALS
        joypad.set(BOT_PLAYER_NUM, { A = false })
        emu.frameadvance()
    end
end

function swapAtAllPosInTable(moves)
    if #moves > 0 then
        print("swapping at " .. table.toString(moves))
        for _, move in ipairs(moves) do
            --makes sure that the columns that are being swapped aren't empty to make more efficient
            --makes sure top blocks arent the same
            --TODO: i think it's too fast for its own good...
            --TODO: yep, if one stack is taller than the other, it doesn't update in time.
            --TODO: Either find hex value that shows when they're all swapped and wait for that, or let it be stupid.
            --Letting it be stupid for now
            --if not(getTopBlock(getColumn(moves[i] + 1)) == getTopBlock(getColumn(moves[i] + 2))) then

            swapAtPos(move)

            --swap columns in goals for future states as well
            --[[]for i=stateIndex,#states,1 do
                if type(states[i]) == "table" then
                    print("move: "..move)
                    swapTableSubTabs(states[i], move+1, move+2) --0=12,1=23,2=34
                end
            end]]--

            --[[else
                print("avoided looking stupid :D")
                print("didn't swap at pos "..moves[i].." because both sides are "..getTopBlock(getColumn(moves[i] + 1)))
            end]] --
        end
    end
    return states
end

function moveColumn(column, targetPos)
    if column > 0 then
        --TODO: column 1 to pos 2 results in a swap position of 1 instead of 0
        --TODO: make it work for A, 5, high, 1
        print("need to move column " .. column .. " to position " .. targetPos)
        local range = targetPos - column
        local sign = range / math.abs(range)
        --QUESTION: why the hell does it run when they're equal
        print("iterating from 0 to " .. math.abs(range))
        if range ~= 0 then
            for i = 0, math.abs(range) - 1 do
                swapAtPos(column + (i * sign) + ((sign - 3) / 2))
            end
        end
    end
end

--pauses for a random amount of time
--TODO doc
function randomPause(max)
    max = max or 5 --default value 5
    for _ = 0, math.random(max) do
        emu.frameadvance()
    end
end

function applySettings(settings)
    --starts game
    --TODO: make into a function
    --TODO: make sure selector is in the right place instead of counting frames

    local numPlayers = tonumber(settings[1])

    --replace numbered music with string version
    if numPlayers == 1 and tonumber(settings[5]) ~= nil then
        local bgmTypes = { "mushroom", "flower", "star", "off" }
        settings[5] = bgmTypes[tonumber(settings[5])]
    end

    local randomize = settings[6] == "on" -- same pos for 1p vs 2p
    math.randomseed(os.time())

    --while egg cursor hasnt appeared on start menu
    while MemMap.startMenuSelectorStatus() ~= 1 do
        emu.frameadvance()
    end
    while MemMap.startMenuSelectorStatus() ~= numPlayers do
        joypad.set(1, { down = true })
        emu.frameadvance()
        emu.frameadvance()
    end

    joypad.set(1, { start = true })
    emu.frameadvance()

    --while settings menu hasnt appeared
    while MemMap.settingsMenuSelectorStatus() do
        emu.frameadvance()
    end

    if randomize then
        randomPause()
    end

    local settingsFuncs = numPlayers == 1 and { MemMap.menuSettGame, MemMap.menuSettLevel, MemMap.menuSettSpeed, MemMap.menuSettBGM } or { MemMap.menuSettLevel, MemMap.menuSettSpeed }

    for i, func in ipairs(settingsFuncs) do
        for pNum = 1, numPlayers do
            local settingName = MemMap.menuSettName(numPlayers == 1 and 0 or pNum)
            -- (2*pNum + i - 1) solved using gaussian elimination B)
            while tostring(func(numPlayers == 1 and 0 or pNum)) ~= settings[(numPlayers == 1 and i + 1 or (2 * pNum + i - 1))] do
                joypad.set(pNum, { right = true })
                emu.frameadvance()
                emu.frameadvance()
            end
            if randomize then
                randomPause()
            end
            if settingName ~= (numPlayers == 1 and "bgm" or "speed") then
                while MemMap.menuSettName(numPlayers == 1 and 0 or pNum) == settingName do
                    joypad.set(pNum, { down = true })
                    emu.frameadvance()
                    emu.frameadvance()
                end
            end
            print("[set " .. (numPlayers == 1 and " " or ("player " .. pNum .. "'s ")) .. settingName .. " to " .. settings[(numPlayers == 1 and i + 1 or (2 * pNum + i - 1))] .. "]")
        end
    end

    joypad.set(1, { start = true })
    emu.frameadvance()
end

--[[ NEW FUNCTIONS ]]--

function dropUntilNumBlocksFalling(num)
    while num < MemMap.numFallingBlocks() do
        joypad.set(BOT_PLAYER_NUM, { down = true })
        emu.frameadvance()
    end
end