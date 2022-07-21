---Concatenates two tables. (adds second table onto end of first table)
---https://stackoverflow.com/a/15278426/12861567
---@param table1 table first table
---@param table2 table second table
---@return table the two tables concatenated together
function concatTables(table1, table2)
    for _, v in ipairs(table2) do
        table1[#table1 + 1] = v
    end
    return table1
end

---Creates a string out of a table.
---Modified from https://stackoverflow.com/a/22460068/12861567
---@param tab table the table to make a string out of
---@return string the table represented as a string
function table.toString(tab)
    --TODO: maybe shouldn't be table.toString bc that's not right
    if tab then
        local tabString = ""
        for _, v in ipairs(tab) do
            tabString = tabString .. (type(v) == "table" and table.toString(v) or v) .. ", "
        end
        return string.sub(tabString, 1, #tabString - 2)
    else
        return ""
    end
end

---Checks if the given table contains the given value.
---from: https://stackoverflow.com/a/33511182/12861567
---@param table table<any> the table to check
---@param value any the value to look for
---@return boolean true if the value is found, false if not
function hasValue(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

---Checks if the every value in the given table equals the given value.
---based on hasValue
---@param table table<any> the table to check
---@param value any the value to look for
---@return boolean true if only the value is found, false if not
function onlyHasValue(table, value)
    for _, v in pairs(table) do
        if not (v == value) then
            return false
        end
    end
    return true
end

---Counts the number of times the given value is present in the given table.
---@param table table<any> the table to check
---@param value any the value to look for
---@return number the number of instances of the value found in the table
function instancesOf(table, value)
    inst = 0
    for _, v in pairs(table) do
        if v == value then
            inst = inst + 1
        end
    end
    return inst
end

---Finds and returns the first index of the given value in the given table.
---@param table table<any> the table to check
---@param value any the value to look for
---@return number the first index of the value in the table
function firstIndexOf(table, value)
    for i, v in ipairs(table) do
        if v == value then
            return i
        end
    end
    return 0
end

-- checks if tables are equal in order and contents
--TODO doc
function tablesEqualOrder(table1, table2, wildcard)
    for i = 1, #table1 do
        -- if values are the same, or, if a wildcard was provided, if either of the two equal the wildcard
        if not (table1[i] == table2[i] or (wildcard ~= nil and (table1[i] == wildcard or table2[i] == wildcard))) then
            return false
        end
    end
    return true
end

--TODO doc
function areConsecutiveNums(num1, num2)
    --same as (num1 + 1 == num2) or (num1 - 1 == num2)
    return (num1 + 1 == num2) or (num2 + 1 == num1)
end

--TODO doc
--TODO: if they were passed as params, then I modified the table, would it modify the og value?
function swapTableSubTabs(table, index1, index2)
    local temp = table[index1]
    table[index1] = table[index2]
    table[index2] = temp
    return table
end

--https://stackoverflow.com/a/11671820/12861567
--TODO doc
function map(tab, func)
    local mapped = {}
    for i, v in ipairs(tab) do
        mapped[i] = func(v)
    end
    return mapped
end

function copy(tab)
    local new_tab = {}
    for k, v in pairs(tab) do
        new_tab[k] = type(v) == "table" and copy(v) or v
    end
    return new_tab
end

--TODO doc
function replace(table, v1, v2)
    --TODO typecheck maybe
    for i, v in ipairs(table) do
        if v == v1 then
            table[i] = v2
        end
    end
    return table
end

--TODO doc
--converts a table of items into a dictionary of the count of each item
function tableToInvertedDict(table)
    local dict = {}
    for _, v in ipairs(table) do
        dict[v] = dict[v] == nil and 1 or dict[v] + 1
    end
    return dict
end

-- TODO doc
-- converts table to flattened table
function flattenTable(table)
    local flattened = {}
    for _, v in ipairs(table) do
        if type(v) == "table" then
            for _, v2 in ipairs(flattenTable(v)) do
                flattened[#flattened + 1] = v2
            end
        else
            flattened[#flattened + 1] = v
        end
    end
    return flattened
end