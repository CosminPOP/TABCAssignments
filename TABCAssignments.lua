local _G = _G
local me = UnitName('player')

local TABCA = CreateFrame("Frame")

local core = TABCA

core.type = type
core.select = select
core.floor = math.floor
core.ceil = math.ceil
core.max = math.max
core.min = math.min
core.rep = string.rep
core.sub = string.sub
core.int = tonumber
core.lower = string.lower
core.upper = string.upper
core.find = string.find
core.format = string.format
core.byte = string.byte
core.char = string.char
core.len = string.len
core.gsub = string.gsub
core.rep = string.rep
core.tostring = tostring
core.pairs = pairs
core.ipairs = ipairs
core.sort = table.sort
core.insert = table.insert
core.wipe = table.wipe

core.split = function(delimiter, str)
    local result = {}
    local from = 1
    local delim_from, delim_to = core.find(str, delimiter, from)
    while delim_from do
        core.insert(result, core.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = core.find(str, delimiter, from)
    end
    core.insert(result, core.sub(str, from))
    return result
end

local TABCATargetsDropDown = CreateFrame('Frame', 'TABCATargetsDropDown', UIParent, 'UIDropDownMenuTemplate')
TABCATargetsDropDown:Hide()
local TABCATanksDropDown = CreateFrame('Frame', 'TABCATanksDropDown', UIParent, 'UIDropDownMenuTemplate')
TABCATanksDropDown:Hide()
local TABCAHealersDropDown = CreateFrame('Frame', 'TABCAHealersDropDown', UIParent, 'UIDropDownMenuTemplate')
TABCAHealersDropDown:Hide()

local TABCATemplates = CreateFrame('Frame', 'TABCATemplates', UIParent, 'UIDropDownMenuTemplate')

function twaprint(a)
    if a == nil then
        DEFAULT_CHAT_FRAME:AddMessage('|cff69ccf0[TABCA]|cff0070de:' .. time() .. '|cffffffff attempt to print a nil value.')
        return false
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cff69ccf0[TABCA] |cffffffff" .. a)
end

function twaerror(a)
    DEFAULT_CHAT_FRAME:AddMessage('|cff69ccf0[TABCA]|cff0070de:' .. time() .. '|cffffffff[' .. a .. ']')
end

function twadebug(a)
    --twaprint('|cff0070de[TWADEBUG:' .. time() .. ']|cffffffff[' .. a .. ']')
end

TABCA:RegisterEvent("ADDON_LOADED")
TABCA:RegisterEvent("RAID_ROSTER_UPDATE")
TABCA:RegisterEvent("CHAT_MSG_ADDON")
TABCA:RegisterEvent("CHAT_MSG_WHISPER")

TABCA.data = {}

core.templates = {
    ['trash1'] = {
        [1] = { "Skull", "-", "-", "-", "-", "-", "-" },
        [2] = { "Cross", "-", "-", "-", "-", "-", "-" },
        [3] = { "Square", "-", "-", "-", "-", "-", "-" },
        [4] = { "Moon", "-", "-", "-", "-", "-", "-" },
        [5] = { "Star", "-", "-", "-", "-", "-", "-" },
        [6] = { "Circle", "-", "-", "-", "-", "-", "-" },
        [7] = { "Diamond", "-", "-", "-", "-", "-", "-" },
        [8] = { "Triangle", "-", "-", "-", "-", "-", "-" },
    },
    ['trash2'] = {
        [1] = { "Skull", "-", "-", "-", "-", "-", "-" },
        [2] = { "Cross", "-", "-", "-", "-", "-", "-" },
        [3] = { "Square", "-", "-", "-", "-", "-", "-" },
        [4] = { "Moon", "-", "-", "-", "-", "-", "-" },
        [5] = { "Star", "-", "-", "-", "-", "-", "-" },
        [6] = { "Circle", "-", "-", "-", "-", "-", "-" },
        [7] = { "Diamond", "-", "-", "-", "-", "-", "-" },
        [8] = { "Triangle", "-", "-", "-", "-", "-", "-" },
    },
    ['trash3'] = {
        [1] = { "Skull", "-", "-", "-", "-", "-", "-" },
        [2] = { "Cross", "-", "-", "-", "-", "-", "-" },
        [3] = { "Square", "-", "-", "-", "-", "-", "-" },
        [4] = { "Moon", "-", "-", "-", "-", "-", "-" },
        [5] = { "Star", "-", "-", "-", "-", "-", "-" },
        [6] = { "Circle", "-", "-", "-", "-", "-", "-" },
        [7] = { "Diamond", "-", "-", "-", "-", "-", "-" },
        [8] = { "Triangle", "-", "-", "-", "-", "-", "-" },
    },
    ['trash4'] = {
        [1] = { "Skull", "-", "-", "-", "-", "-", "-" },
        [2] = { "Cross", "-", "-", "-", "-", "-", "-" },
        [3] = { "Square", "-", "-", "-", "-", "-", "-" },
        [4] = { "Moon", "-", "-", "-", "-", "-", "-" },
        [5] = { "Star", "-", "-", "-", "-", "-", "-" },
        [6] = { "Circle", "-", "-", "-", "-", "-", "-" },
        [7] = { "Diamond", "-", "-", "-", "-", "-", "-" },
        [8] = { "Triangle", "-", "-", "-", "-", "-", "-" },
    },
    ['trash5'] = {
        [1] = { "Skull", "-", "-", "-", "-", "-", "-" },
        [2] = { "Cross", "-", "-", "-", "-", "-", "-" },
        [3] = { "Square", "-", "-", "-", "-", "-", "-" },
        [4] = { "Moon", "-", "-", "-", "-", "-", "-" },
        [5] = { "Star", "-", "-", "-", "-", "-", "-" },
        [6] = { "Circle", "-", "-", "-", "-", "-", "-" },
        [7] = { "Diamond", "-", "-", "-", "-", "-", "-" },
        [8] = { "Triangle", "-", "-", "-", "-", "-", "-" },
    },
    ['anub'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Skull", "-", "-", "-", "-", "-", "-" },
        [3] = { "Cross", "-", "-", "-", "-", "-", "-" },
        [4] = { "Raid", "-", "-", "-", "-", "-", "-" },
    },
    ['faerlina'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [3] = { "Adds", "-", "-", "-", "-", "-", "-" },
        [4] = { "Skull", "-", "-", "-", "-", "-", "-" },
        [5] = { "Cross", "-", "-", "-", "-", "-", "-" },
    },
    ['maexxna'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [3] = { "Wall", "-", "-", "-", "-", "-", "-" },
        [4] = { "Wall", "-", "-", "-", "-", "-", "-" },
    },
    ['noth'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "NorthWest", "-", "-", "-", "-", "-", "-" },
        [3] = { "SouthWest", "-", "-", "-", "-", "-", "-" },
        [4] = { "NorthEast", "-", "-", "-", "-", "-", "-" },
    },
    ['heigan'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Melee", "-", "-", "-", "-", "-", "-" },
        [3] = { "Dispels", "-", "-", "-", "-", "-", "-" },
    },
    ['loatheb'] = {
            [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
            [2] = { "Melee", "-", "-", "-", "-", "-", "-" },
            [3] = { "Dispels", "-", "-", "-", "-", "-", "-" },
        },
    ['raz'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Skull", "-", "-", "-", "-", "-", "-" },
        [3] = { "Cross", "-", "-", "-", "-", "-", "-" },
        [4] = { "Moon", "-", "-", "-", "-", "-", "-" },
        [5] = { "Square", "-", "-", "-", "-", "-", "-" },
    },
    ['gothik'] = {
        [1] = { "Living", "-", "-", "-", "-", "-", "-" },
        [2] = { "Living", "-", "-", "-", "-", "-", "-" },
        [3] = { "Dead", "-", "-", "-", "-", "-", "-" },
        [4] = { "Dead", "-", "-", "-", "-", "-", "-" },
    },
    ['4h'] = {
        [1] = { "Skull", "-", "-", "-", "-", "-", "-" },
        [2] = { "Cross", "-", "-", "-", "-", "-", "-" },
        [3] = { "Moon", "-", "-", "-", "-", "-", "-" },
        [4] = { "Square", "-", "-", "-", "-", "-", "-" },
    },
    ['patchwerk'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Soaker", "-", "-", "-", "-", "-", "-" },
        [3] = { "Soaker", "-", "-", "-", "-", "-", "-" },
        [4] = { "Soaker", "-", "-", "-", "-", "-", "-" },
    },
    ['grobulus'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Melee", "-", "-", "-", "-", "-", "-" },
        [3] = { "Dispells", "-", "-", "-", "-", "-", "-" },
    },
    ['gluth'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Adds", "-", "-", "-", "-", "-", "-" },
    },
    ['thaddius'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Left", "-", "-", "-", "-", "-", "-" },
        [3] = { "Left", "-", "-", "-", "-", "-", "-" },
        [4] = { "Right", "-", "-", "-", "-", "-", "-" },
        [5] = { "Right", "-", "-", "-", "-", "-", "-" },
    },
    ['saph'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [3] = { "Group 1", "-", "-", "-", "-", "-", "-" },
        [4] = { "Group 2", "-", "-", "-", "-", "-", "-" },
        [5] = { "Group 3", "-", "-", "-", "-", "-", "-" },
        [6] = { "Group 4", "-", "-", "-", "-", "-", "-" },
        [7] = { "Group 5", "-", "-", "-", "-", "-", "-" },
        [8] = { "Group 6", "-", "-", "-", "-", "-", "-" },
        [9] = { "Group 7", "-", "-", "-", "-", "-", "-" },
        [10] = { "Group 8", "-", "-", "-", "-", "-", "-" },
    },
    ['kt'] = {
        [1] = { "BOSS", "-", "-", "-", "-", "-", "-" },
        [2] = { "Raid", "-", "-", "-", "-", "-", "-" },
    },

}

TABCA.loadedTemplate = ''

function TABCA_loadTemplate(template, load)
    if load ~= nil and load == true then
        TABCA.data = {}
        for i, d in next, core.templates[template] do
            TABCA.data[i] = d
        end
        TABCA:PopulateTABCA()
        twaprint('Loaded template |cff69ccf0' .. template)
        TABCA_MainTemplates:SetText(template)
        TABCA.loadedTemplate = template
        return true
    end
    ChatThrottleLib:SendAddonMessage("ALERT", "TABCA", "LoadTemplate=" .. template, "RAID")
end

function TABCA_loadTemplate_s(s, a1, a2)
    tabca_closeDropdown()
    TABCA_loadTemplate(a1, a2)
end

--default
TABCA.raid = {
    ['warrior'] = {},
    ['paladin'] = {},
    ['druid'] = {},
    ['warlock'] = {},
    ['mage'] = {},
    ['priest'] = {},
    ['rogue'] = {},
    ['shaman'] = {},
    ['hunter'] = {},
    ['deathknight'] = {},
}

TABCA.classes = {
    ['Warriors'] = 'warrior',
    ['Paladins'] = 'paladin',
    ['Druids'] = 'druid',
    ['Warlocks'] = 'warlock',
    ['Mages'] = 'mage',
    ['Priests'] = 'priest',
    ['Rogues'] = 'rogue',
    ['Shamans'] = 'shaman',
    ['Hunters'] = 'hunter',
    ['Deathknights'] = 'deathknight',
}

TABCA.classColors = {
    ["warrior"] = { r = 0.78, g = 0.61, b = 0.43, c = "|cffc79c6e" },
    ["mage"] = { r = 0.41, g = 0.8, b = 0.94, c = "|cff69ccf0" },
    ["rogue"] = { r = 1, g = 0.96, b = 0.41, c = "|cfffff569" },
    ["druid"] = { r = 1, g = 0.49, b = 0.04, c = "|cffff7d0a" },
    ["hunter"] = { r = 0.67, g = 0.83, b = 0.45, c = "|cffabd473" },
    ["shaman"] = { r = 0.14, g = 0.35, b = 1.0, c = "|cff0070de" },
    ["priest"] = { r = 1, g = 1, b = 1, c = "|cffffffff" },
    ["warlock"] = { r = 0.58, g = 0.51, b = 0.79, c = "|cff9482c9" },
    ["paladin"] = { r = 0.96, g = 0.55, b = 0.73, c = "|cfff58cba" },
    ["deathknight"] = { r = 0.77, g = 0.12, b = 0.23, c = "|cffC41F3B" },
}

TABCA.marks = {
    ['Star'] = TABCA.classColors['rogue'].c,
    ['Circle'] = TABCA.classColors['druid'].c,
    ['Diamond'] = TABCA.classColors['paladin'].c,
    ['Triangle'] = TABCA.classColors['hunter'].c,
    ['Moon'] = '|cffffffff',
    ['Square'] = TABCA.classColors['mage'].c,
    ['Cross'] = '|cffff0000',
    ['Skull'] = '|cffffffff',
}

TABCA.sides = {
    --if changed also change in buildTargetsDropdown !
    ['Left'] = TABCA.classColors['warlock'].c,
    ['Right'] = TABCA.classColors['mage'].c,
}
TABCA.coords = {
    --if changed also change in buildTargetsDropdown !
    ['North'] = '|cffffffff',
    ['South'] = '|cffffffff',
    ['East'] = '|cffffffff',
    ['West'] = '|cffffffff',
    ['NorthWest'] = TABCA.classColors['rogue'].c,
    ['NorthEast'] = TABCA.classColors['rogue'].c,
    ['SouthEast'] = TABCA.classColors['rogue'].c,
    ['SouthWest'] = TABCA.classColors['rogue'].c,
}
TABCA.misc = {
    ['Raid'] = TABCA.classColors['shaman'].c,
    ['Melee'] = TABCA.classColors['rogue'].c,
    ['Ranged'] = TABCA.classColors['mage'].c,
    ['Adds'] = TABCA.classColors['paladin'].c,
    ['BOSS'] = '|cffff3333',
    ['Enrage'] = '|cffff7777',
    ['Wall'] = TABCA.classColors['hunter'].c,
    ['Living'] = TABCA.classColors['warrior'].c,
    ['Dead'] = TABCA.classColors['druid'].c,
    ['Dispels'] = TABCA.classColors['mage'].c,
    ['Soaker'] = TABCA.classColors['druid'].c,
}

TABCA.groups = {
    ['Group 1'] = TABCA.classColors['priest'].c,
    ['Group 2'] = TABCA.classColors['priest'].c,
    ['Group 3'] = TABCA.classColors['priest'].c,
    ['Group 4'] = TABCA.classColors['priest'].c,
    ['Group 5'] = TABCA.classColors['priest'].c,
    ['Group 6'] = TABCA.classColors['priest'].c,
    ['Group 7'] = TABCA.classColors['priest'].c,
    ['Group 8'] = TABCA.classColors['priest'].c,
}

TABCA:SetScript("OnEvent", function()
    if event then
        if event == "ADDON_LOADED" and arg1 == "TABCAssignments" then
            twaprint("TABCA Loaded")
            if not TABCA_PRESETS then
                TABCA_PRESETS = {}
            end
            if not TABCA_DATA then
                TABCA_DATA = {
                    [1] = { '-', '-', '-', '-', '-', '-', '-' },
                }
                TABCA.data = TABCA_DATA
            end
            TABCA.data = TABCA_DATA
            TABCA:fillRaidData()
            TABCA:PopulateTABCA()
        end
        if event == "RAID_ROSTER_UPDATE" then
            TABCA:fillRaidData()
            TABCA:PopulateTABCA()
        end
        if event == 'CHAT_MSG_ADDON' and arg1 == "TABCA" then
            twadebug(arg4 .. ' says: ' .. arg2)
            TABCA:handleSync(arg1, arg2, arg3, arg4)
        end
--         if event == 'CHAT_MSG_ADDON' and arg1 == "QH" then
--             TWA.handleQHSync(arg1, arg2, arg3, arg4)
--         end
        if event == 'CHAT_MSG_WHISPER' then
            if arg1 == 'heal' then
                local lineToSend = ''
                for _, row in next, TABCA.data do
                    local mark = ''
                    local tank = ''
                    for i, cell in next, row do
                        if i == 1 then
                            mark = cell
                            tank = mark

                            if mark == 'Skull' then mark = '{skull}' end
                            if mark == 'Cross' then mark = '{cross}' end
                            if mark == 'Square' then mark = '{square}' end
                            if mark == 'Moon' then mark = '{moon}' end
                            if mark == 'Triangle' then mark = '{triangle}' end
                            if mark == 'Diamond' then mark = '{diamond}' end
                            if mark == 'Circle' then mark = '{circle}' end
                            if mark == 'Star' then mark = '{star}' end
                        end
                        if i == 2 or i == 3 or i == 4 then
                            if cell ~= '-' then
                                tank = ''
                            end
                        end
                        if i == 2 or i == 3 or i == 4 then
                            if cell ~= '-' then
                                tank = tank .. cell .. ' '
                            end
                        end
                        if arg2 == cell then
                            if i == 2 or i == 3 or i == 4 then
                                if lineToSend == '' then
                                    lineToSend = 'You are assigned to ' .. mark
                                else
                                    lineToSend = lineToSend .. ' and ' .. mark
                                end
                            end
                            if i == 5 or i == 6 or i == 7 then
                                if lineToSend == '' then
                                    lineToSend = 'You are assigned to Heal ' .. tank
                                else
                                    lineToSend = lineToSend .. ' and ' .. tank
                                end
                            end
                        end
                    end
                end
                if lineToSend == '' then
                    ChatThrottleLib:SendChatMessage("BULK", "TABCA", 'You are not assigned.', "WHISPER", "Common", arg2);
                else
                    ChatThrottleLib:SendChatMessage("BULK", "TABCA", lineToSend, "WHISPER", "Common", arg2);
                end
            end
        end
    end
end)

function TABCA:markOrPlayerUsed(markOrPlayer)
    for _, data in next, TABCA.data do
        for _, as in next, data do
            if as == markOrPlayer then
                return true
            end
        end
    end
    return false
end

function TABCA:fillRaidData()
    twadebug('fill raid data')
    TABCA.raid = {
        ['warrior'] = {},
        ['paladin'] = {},
        ['druid'] = {},
        ['warlock'] = {},
        ['mage'] = {},
        ['priest'] = {},
        ['rogue'] = {},
        ['shaman'] = {},
        ['hunter'] = {},
        ['deathknight'] = {},
    }
    for i = 0, GetNumRaidMembers() do
        if GetRaidRosterInfo(i) then
            local name, _, _, _, _, _, z = GetRaidRosterInfo(i);
            local _, unitClass = UnitClass('raid' .. i)
            unitClass = core.lower(unitClass)
            core.insert(TABCA.raid[unitClass], name)
        end
    end
end

function TABCA:isPlayerOffline(name)
    for i = 0, GetNumRaidMembers() do
        if (GetRaidRosterInfo(i)) then
            local n, _, _, _, _, _, z = GetRaidRosterInfo(i);
            if n == name and z == 'Offline' then
                return true
            end
        end
    end
    return false
end

function TABCA:handleSync(pre, t, ch, sender)

    if core.find(t, 'LoadTemplate=', 1, true) then
        local tempEx = core.split('=', t)
        if not tempEx[2] then
            return false
        end
        TABCA_loadTemplate(tempEx[2], true)
        return true
    end

    if core.find(t, 'SendTable=', 1, true) then
        local sendEx = core.split('=', t)
        if not sendEx[2] then
            return false
        end

        if sendEx[2] == me then
            ChatThrottleLib:SendAddonMessage("ALERT", "TABCA", "FullSync=start", "RAID")
            for _, data in next, TABCA.data do
                ChatThrottleLib:SendAddonMessage("ALERT", "TABCA", "FullSync=" ..
                        data[1] .. '=' ..
                        data[2] .. '=' ..
                        data[3] .. '=' ..
                        data[4] .. '=' ..
                        data[5] .. '=' ..
                        data[6] .. '=' ..
                        data[7], "RAID")
            end
            ChatThrottleLib:SendAddonMessage("ALERT", "TABCA", "FullSync=end", "RAID")
        end
        return true
    end

    if core.find(t, 'FullSync=', 1, true) and sender ~= me then
        local sEx = core.split('=', t)
        if sEx[2] == 'start' then
            TABCA.data = {}
        elseif sEx[2] == 'end' then
            TABCA:PopulateTABCA()
        else
            if sEx[2] and sEx[3] and sEx[4] and sEx[5] and sEx[6] and sEx[7] and sEx[8] then
                local index = #TABCA.data + 1
                TABCA.data[index] = {}
                TABCA.data[index][1] = sEx[2]
                TABCA.data[index][2] = sEx[3]
                TABCA.data[index][3] = sEx[4]
                TABCA.data[index][4] = sEx[5]
                TABCA.data[index][5] = sEx[6]
                TABCA.data[index][6] = sEx[7]
                TABCA.data[index][7] = sEx[8]
            end
        end
        return true
    end

    if core.find(t, 'ChangeCell=', 1, true) then
        local changeEx = TABCA.split('=', t)
        --if not changeEx[2] or not changeEx[3] or not changeEx[4] then
        if not changeEx[3] then
            print("split error")
            return false
        end
        --TABCA:change(tonumber(changeEx[2]), changeEx[3], sender, changeEx[4] == '1')
        TABCA:change(core.int(changeEx[2]), changeEx[3], sender)
        return true
    end
    if core.find(t, 'Reset', 1, true) then
        TABCA:Reset()
        return true
    end
end

-- not used yet
function TABCA:handleQHSync(pre, t, ch, sender)

    if sender ~= me then
        local roster
        local tanks = 'Tanks='
        local healers = 'Healers='

        if core.find(t, 'RequestRoster', 1, true) then -- QH roster request

            for _, data in next, TABCA.data do -- build roster string
                for i, name in next, data do
                    if i == 2 or i == 3 or i == 4 then
                        if name ~= '-' then
                            if core.len(tanks) == 6 then -- skip ',' delimiter if this is the first tank entry
                                tanks = tanks .. name
                            else
                                tanks = tanks .. "," .. name
                            end
                        end
                    end
                    if i == 5 or i == 6 or i == 7 then
                        if name ~= '-' then
                            if core.len(healers) == 8 then -- skip ',' delimiter if this is the first healer entry
                                healers = healers .. name
                            else
                                healers = healers .. "," .. name
                            end
                        end
                    end
                end
            end
            roster = tanks .. ";" .. healers;
            ChatThrottleLib:SendAddonMessage("ALERT", "TABCA", roster, "RAID") -- transmit roster
        end
    end
end

TABCA.rows = {}
TABCA.cells = {}

function tabca_changeCell(self, xy, to)
    tabca_closeDropdown()
    TABCA:changeCell(xy, to)
end

function TABCA:changeCell(xy, to)
    ChatThrottleLib:SendAddonMessage("ALERT", "TABCA", "ChangeCell=" .. xy .. "=" .. to, "RAID")
end

function TABCA:change(xy, to)
    local x = core.floor(xy / 100)
    local y = xy - x * 100

    if to ~= 'clear' then
        TABCA.data[x][y] = to
    else
        TABCA.data[x][y] = '-'
    end

    TABCA:PopulateTABCA()
end

function tabca_closeDropdown()
    CloseDropDownMenus()
end


function TABCA:PopulateTABCA()

    twadebug('PopulateTABCA')

    for i = 1, 25 do
        if TABCA.rows[i] then
            if TABCA.rows[i]:IsVisible() then
                TABCA.rows[i]:Hide()
            end
        end
    end

    for index, data in next, TABCA.data do

        if not TABCA.rows[index] then
            TABCA.rows[index] = CreateFrame('Frame', 'TABCARow' .. index, TABCA_Main, 'TABCARow')
        end

        TABCA.rows[index]:Show()

        TABCA.rows[index]:SetBackdropColor(0, 0, 0, .2);

        TABCA.rows[index]:SetPoint("TOP", TABCA_Main, "TOP", 0, -25 - index * 21)
        if not TABCA.cells[index] then
            TABCA.cells[index] = {}
        end

        local line = ''

        for i, name in next, data do

            if not TABCA.cells[index][i] then
                TABCA.cells[index][i] = CreateFrame('Frame', 'TABCACell' .. index .. i, TABCA.rows[index], 'TABCACell')
            end

            local frame = 'TABCACell' .. index .. i

            _G[frame]:SetPoint("LEFT", TABCA.rows[index], "LEFT", -82 + i * 82, 0)

            _G[frame .. 'Button']:SetID((index * 100) + i)

            local color = TABCA.classColors['priest'].c
            _G[frame]:SetBackdropColor(.2, .2, .2, .7);
            for c, n in next, TABCA.raid do
                for _, raidMember in next, n do
                    if raidMember == name then
                        color = TABCA.classColors[c].c
                        local r = TABCA.classColors[c].r
                        local g = TABCA.classColors[c].g
                        local b = TABCA.classColors[c].b
                        _G[frame]:SetBackdropColor(r, g, b, .7);
                        break
                    end
                end
            end

            if TABCA.marks[name] then
                color = TABCA.marks[name]
            end
            if TABCA.sides[name] then
                color = TABCA.sides[name]
            end
            if TABCA.coords[name] then
                color = TABCA.coords[name]
            end
            if TABCA.misc[name] then
                color = TABCA.misc[name]
            end
            if TABCA.groups[name] then
                color = TABCA.groups[name]
            end

            if name == '-' then
                name = ''
            end

            if TABCA.isPlayerOffline(name) then
                color = '|cffff0000'
            end

            _G[frame .. 'Text']:SetText(color .. name)

            _G[frame .. 'Icon']:Hide()
            _G[frame .. 'Icon']:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");

            if name == 'Skull' then
                getglobal(frame .. 'Icon'):SetTexCoord(0.75, 1, 0.25, 0.5)
                getglobal(frame .. 'Icon'):Show()
            end
            if name == 'Cross' then
                getglobal(frame .. 'Icon'):SetTexCoord(0.5, 0.75, 0.25, 0.5)
                getglobal(frame .. 'Icon'):Show()
            end
            if name == 'Square' then
                getglobal(frame .. 'Icon'):SetTexCoord(0.25, 0.5, 0.25, 0.5)
                getglobal(frame .. 'Icon'):Show()
            end
            if name == 'Moon' then
                getglobal(frame .. 'Icon'):SetTexCoord(0, 0.25, 0.25, 0.5)
                getglobal(frame .. 'Icon'):Show()
            end
            if name == 'Triangle' then
                getglobal(frame .. 'Icon'):SetTexCoord(0.75, 1, 0, 0.25)
                getglobal(frame .. 'Icon'):Show()
            end
            if name == 'Diamond' then
                getglobal(frame .. 'Icon'):SetTexCoord(0.5, 0.75, 0, 0.25)
                getglobal(frame .. 'Icon'):Show()
            end
            if name == 'Circle' then
                getglobal(frame .. 'Icon'):SetTexCoord(0.25, 0.5, 0, 0.25)
                getglobal(frame .. 'Icon'):Show()
            end
            if name == 'Star' then
                getglobal(frame .. 'Icon'):SetTexCoord(0, 0.25, 0, 0.25)
                getglobal(frame .. 'Icon'):Show()
            end

            line = line .. name .. '-'
        end
    end

    TABCA_Main:SetHeight(50 + #TABCA.data * 21)
    TABCA_DATA = TABCA.data
end

function TABCA_Buttoane_OnEnter(id)

    local index = core.floor(id / 100)

    if id < 100 then
        index = id
    end

    getglobal('TABCARow' .. index):SetBackdropColor(1, 1, 1, .2)
end

function TABCA_Buttoane_OnLeave(id)

    local index = core.floor(id / 100)

    if id < 100 then
        index = id
    end

    getglobal('TABCARow' .. index):SetBackdropColor(0, 0, 0, .2)
end

function TABCA_buildTargetsDropdown()

    if UIDROPDOWNMENU_MENU_LEVEL == 1 then

        --local Trash = {}
        --Trash.text = "Trash"
        --Trash.isTitle = true
        --UIDropDownMenu_AddButton(Trash, UIDROPDOWNMENU_MENU_LEVEL);

        local Title = {}
        Title.text = "Targets"
        Title.isTitle = true
        UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

        local Marks = {}
        Marks.text = TABCA.classColors['mage'].c .. "Marks"
        Marks.notCheckable = true
        Marks.hasArrow = true
        Marks.value = {
            ['key'] = 'marks'
        }
        UIDropDownMenu_AddButton(Marks, UIDROPDOWNMENU_MENU_LEVEL);

        local Sides = {}
        Sides.text = "Sides"
        Sides.notCheckable = true
        Sides.hasArrow = true
        Sides.value = {
            ['key'] = 'sides'
        }
        UIDropDownMenu_AddButton(Sides, UIDROPDOWNMENU_MENU_LEVEL);

        local Coords = {}
        Coords.text = "Coords"
        Coords.notCheckable = true
        Coords.hasArrow = true
        Coords.value = {
            ['key'] = 'coords'
        }
        UIDropDownMenu_AddButton(Coords, UIDROPDOWNMENU_MENU_LEVEL);

        local Targets = {}
        Targets.text = "Misc"
        Targets.notCheckable = true
        Targets.hasArrow = true
        Targets.value = {
            ['key'] = 'misc'
        }
        UIDropDownMenu_AddButton(Targets, UIDROPDOWNMENU_MENU_LEVEL);

        local Groups = {}
        Groups.text = "Groups"
        Groups.notCheckable = true
        Groups.hasArrow = true
        Groups.value = {
            ['key'] = 'groups'
        }
        UIDropDownMenu_AddButton(Groups, UIDROPDOWNMENU_MENU_LEVEL);

        local separator = {};
        separator.text = ""
        separator.disabled = true
        UIDropDownMenu_AddButton(separator);

        local clear = {};
        clear.text = "clear"
        clear.disabled = false
        clear.isTitle = false
        clear.notCheckable = true
        clear.func = tabca_changeCell;
        clear.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
        clear.arg2 = 'clear'
        UIDropDownMenu_AddButton(clear, UIDROPDOWNMENU_MENU_LEVEL);

        local close = {};
        close.text = "Close"
        close.disabled = false
        close.notCheckable = true
        close.isTitle = false
        close.func = tabca_closeDropdown
        UIDropDownMenu_AddButton(close, UIDROPDOWNMENU_MENU_LEVEL);
    end

    if UIDROPDOWNMENU_MENU_LEVEL == 2 then

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'marks') then

            local Title = {}
            Title.text = "Marks"
            Title.isTitle = true
            UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

            local separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            for mark, color in next, TABCA.marks do

                local dropdownItem = {}
                dropdownItem.text = color .. mark
                dropdownItem.checked = TABCA:markOrPlayerUsed(mark)

                dropdownItem.icon = 'Interface\\TargetingFrame\\UI-RaidTargetingIcons'

                if mark == 'Skull' then
                    dropdownItem.tCoordLeft = 0.75
                    dropdownItem.tCoordRight = 1
                    dropdownItem.tCoordTop = 0.25
                    dropdownItem.tCoordBottom = 0.5
                end
                if mark == 'Cross' then
                    dropdownItem.tCoordLeft = 0.5
                    dropdownItem.tCoordRight = 0.75
                    dropdownItem.tCoordTop = 0.25
                    dropdownItem.tCoordBottom = 0.5
                end
                if mark == 'Square' then
                    dropdownItem.tCoordLeft = 0.25
                    dropdownItem.tCoordRight = 0.5
                    dropdownItem.tCoordTop = 0.25
                    dropdownItem.tCoordBottom = 0.5
                end
                if mark == 'Moon' then
                    dropdownItem.tCoordLeft = 0
                    dropdownItem.tCoordRight = 0.25
                    dropdownItem.tCoordTop = 0.25
                    dropdownItem.tCoordBottom = 0.5
                end
                if mark == 'Triangle' then
                    dropdownItem.tCoordLeft = 0.75
                    dropdownItem.tCoordRight = 1
                    dropdownItem.tCoordTop = 0
                    dropdownItem.tCoordBottom = 0.25
                end
                if mark == 'Diamond' then
                    dropdownItem.tCoordLeft = 0.5
                    dropdownItem.tCoordRight = 0.75
                    dropdownItem.tCoordTop = 0
                    dropdownItem.tCoordBottom = 0.25
                end
                if mark == 'Circle' then
                    dropdownItem.tCoordLeft = 0.25
                    dropdownItem.tCoordRight = 0.5
                    dropdownItem.tCoordTop = 0
                    dropdownItem.tCoordBottom = 0.25
                end
                if mark == 'Star' then
                    dropdownItem.tCoordLeft = 0
                    dropdownItem.tCoordRight = 0.25
                    dropdownItem.tCoordTop = 0
                    dropdownItem.tCoordBottom = 0.25
                end

                dropdownItem.func = tabca_changeCell;
                dropdownItem.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
                dropdownItem.arg2 = mark
                UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
                dropdownItem = nil
            end
        end

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'sides') then

            local Title = {}
            Title.text = "Sides"
            Title.isTitle = true
            UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

            local separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            local left = {};
            left.text = TABCA.sides['Left'] .. 'Left'
            left.checked = TABCA:markOrPlayerUsed('Left')
            left.func = tabca_changeCell;
            left.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
            left.arg2 = 'Left'
            UIDropDownMenu_AddButton(left, UIDROPDOWNMENU_MENU_LEVEL);

            local right = {};
            right.text = TABCA.sides['Right'] .. 'Right'
            right.checked = TABCA:markOrPlayerUsed('Right')
            right.func = tabca_changeCell;
            right.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
            right.arg2 = 'Right'
            UIDropDownMenu_AddButton(right, UIDROPDOWNMENU_MENU_LEVEL);
        end

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'coords') then

            local Title = {}
            Title.text = "Coords"
            Title.isTitle = true
            UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

            local separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            local n = {};
            n.text = TABCA.coords['North'] .. 'North'
            n.checked = TABCA:markOrPlayerUsed('North')
            n.func = tabca_changeCell
            n.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
            n.arg2 = 'North'
            UIDropDownMenu_AddButton(n, UIDROPDOWNMENU_MENU_LEVEL);
            local s = {};
            s.text = TABCA.coords['South'] .. 'South'
            s.checked = TABCA:markOrPlayerUsed('South')
            s.func = tabca_changeCell
            s.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
            s.arg2 = 'South'
            UIDropDownMenu_AddButton(s, UIDROPDOWNMENU_MENU_LEVEL);
            local e = {};
            e.text = TABCA.coords['East'] .. 'East'
            e.checked = TABCA:markOrPlayerUsed('East')
            e.func = tabca_changeCell
            e.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
            e.arg2 = 'East'
            UIDropDownMenu_AddButton(e, UIDROPDOWNMENU_MENU_LEVEL);
            local w = {};
            w.text = TABCA.coords['West'] .. 'West'
            w.checked = TABCA:markOrPlayerUsed('West')
            w.func = tabca_changeCell
            w.arg1 =  TABCA.currentRow * 100 + TABCA.currentCell
            w.arg2 = 'West'
            UIDropDownMenu_AddButton(w, UIDROPDOWNMENU_MENU_LEVEL);
        end

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'misc') then

            local Title = {}
            Title.text = "Misc"
            Title.isTitle = true
            UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

            local separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            for mark, color in next, TABCA.misc do
                local markings = {};
                markings.text = color .. mark
                markings.checked = TABCA:markOrPlayerUsed(mark)
                markings.func = tabca_changeCell
                markings.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
                markings.arg2 = mark
                UIDropDownMenu_AddButton(markings, UIDROPDOWNMENU_MENU_LEVEL);
            end
        end

        if (UIDROPDOWNMENU_MENU_VALUE["key"] == 'groups') then

            local Title = {}
            Title.text = "Groups"
            Title.isTitle = true
            UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

            local separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            for mark, color in pairsByKeys(TABCA.groups) do
                local markings = {};
                markings.text = color .. mark
                markings.checked = TABCA:markOrPlayerUsed(mark)
                markings.func = tabca_changeCell
                markings.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
                markings.arg2 = mark
                UIDropDownMenu_AddButton(markings, UIDROPDOWNMENU_MENU_LEVEL);
            end
        end
    end
end

function TABCA_buildTanksDropdown()

    if UIDROPDOWNMENU_MENU_LEVEL == 1 then

        local Title = {}
        Title.text = "Tanks"
        Title.isTitle = true
        UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

        local Warriors = {}
        Warriors.text = TABCA.classColors['warrior'].c .. 'Warriors'
        Warriors.notCheckable = true
        Warriors.hasArrow = true
        Warriors.value = {
            ['key'] = 'warrior'
        }
        UIDropDownMenu_AddButton(Warriors, UIDROPDOWNMENU_MENU_LEVEL);

        local Druids = {}
        Druids.text = TABCA.classColors['druid'].c .. 'Druids'
        Druids.notCheckable = true
        Druids.hasArrow = true
        Druids.value = {
            ['key'] = 'druid'
        }
        UIDropDownMenu_AddButton(Druids, UIDROPDOWNMENU_MENU_LEVEL);

        local Paladins = {}
        Paladins.text = TABCA.classColors['paladin'].c .. 'Paladins'
        Paladins.notCheckable = true
        Paladins.hasArrow = true
        Paladins.value = {
            ['key'] = 'paladin'
        }
        UIDropDownMenu_AddButton(Paladins, UIDROPDOWNMENU_MENU_LEVEL);

        local Deathknights = {}
        Deathknights.text = TABCA.classColors['deathknight'].c .. 'Deathknights'
        Deathknights.notCheckable = true
        Deathknights.hasArrow = true
        Deathknights.value = {
            ['key'] = 'deathknight'
        }
        UIDropDownMenu_AddButton(Deathknights, UIDROPDOWNMENU_MENU_LEVEL);

        local separator = {};
        separator.text = ""
        separator.disabled = true
        UIDropDownMenu_AddButton(separator);

        local Warlocks = {}
        Warlocks.text = TABCA.classColors['warlock'].c .. 'Warlocks'
        Warlocks.notCheckable = true
        Warlocks.hasArrow = true
        Warlocks.value = {
            ['key'] = 'warlock'
        }
        UIDropDownMenu_AddButton(Warlocks, UIDROPDOWNMENU_MENU_LEVEL);

        local Mages = {}
        Mages.text = TABCA.classColors['mage'].c .. 'Mages'
        Mages.notCheckable = true
        Mages.hasArrow = true
        Mages.value = {
            ['key'] = 'mage'
        }
        UIDropDownMenu_AddButton(Mages, UIDROPDOWNMENU_MENU_LEVEL);

        local Priests = {}
        Priests.text = TABCA.classColors['priest'].c .. 'Priests'
        Priests.notCheckable = true
        Priests.hasArrow = true
        Priests.value = {
            ['key'] = 'priest'
        }
        UIDropDownMenu_AddButton(Priests, UIDROPDOWNMENU_MENU_LEVEL);

        local Rogues = {}
        Rogues.text = TABCA.classColors['rogue'].c .. 'Rogues'
        Rogues.notCheckable = true
        Rogues.hasArrow = true
        Rogues.value = {
            ['key'] = 'rogue'
        }
        UIDropDownMenu_AddButton(Rogues, UIDROPDOWNMENU_MENU_LEVEL);

        local Hunters = {}
        Hunters.text = TABCA.classColors['hunter'].c .. 'Hunters'
        Hunters.notCheckable = true
        Hunters.hasArrow = true
        Hunters.value = {
            ['key'] = 'hunter'
        }
        UIDropDownMenu_AddButton(Hunters, UIDROPDOWNMENU_MENU_LEVEL);

        local Shamans = {}
        Shamans.text = TABCA.classColors['shaman'].c .. 'Shamans'
        Shamans.notCheckable = true
        Shamans.hasArrow = true
        Shamans.value = {
            ['key'] = 'shaman'
        }
        UIDropDownMenu_AddButton(Shamans, UIDROPDOWNMENU_MENU_LEVEL);

        separator = {};
        separator.text = ""
        separator.disabled = true
        UIDropDownMenu_AddButton(separator);

        local clear = {};
        clear.text = "clear"
        clear.disabled = false
        clear.isTitle = false
        clear.notCheckable = true
        clear.func = tabca_changeCell;
        clear.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
        clear.arg2 = 'clear'
        UIDropDownMenu_AddButton(clear, UIDROPDOWNMENU_MENU_LEVEL);

        local close = {};
        close.text = "Close"
        close.disabled = false
        close.notCheckable = true
        close.isTitle = false
        close.func = tabca_closeDropdown
        UIDropDownMenu_AddButton(close, UIDROPDOWNMENU_MENU_LEVEL);
    end
    if UIDROPDOWNMENU_MENU_LEVEL == 2 then

        for _, tank in next, TABCA.raid[UIDROPDOWNMENU_MENU_VALUE['key']] do
            local Tanks = {}

            local color = TABCA.classColors[UIDROPDOWNMENU_MENU_VALUE['key']].c

            if TABCA:isPlayerOffline(tank) then
                color = '|cffff0000'
            end

            Tanks.text = color .. tank
            Tanks.checked = TABCA:markOrPlayerUsed(tank)
            Tanks.func = tabca_changeCell
            Tanks.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
            Tanks.arg2 = tank
            UIDropDownMenu_AddButton(Tanks, UIDROPDOWNMENU_MENU_LEVEL);
        end
    end
end

function TABCA_buildHealersDropdown()

    if UIDROPDOWNMENU_MENU_LEVEL == 1 then

        local Healers = {}
        Healers.text = "Healers"
        Healers.isTitle = true
        UIDropDownMenu_AddButton(Healers, UIDROPDOWNMENU_MENU_LEVEL);

        local Priests = {}
        Priests.text = TABCA.classColors['priest'].c .. 'Priests'
        Priests.notCheckable = true
        Priests.hasArrow = true
        Priests.value = {
            ['key'] = 'priest'
        }
        UIDropDownMenu_AddButton(Priests, UIDROPDOWNMENU_MENU_LEVEL);

        local Druids = {}
        Druids.text = TABCA.classColors['druid'].c .. 'Druids'
        Druids.notCheckable = true
        Druids.hasArrow = true
        Druids.value = {
            ['key'] = 'druid'
        }
        UIDropDownMenu_AddButton(Druids, UIDROPDOWNMENU_MENU_LEVEL);

        local Shamans = {}
        Shamans.text = TABCA.classColors['shaman'].c .. 'Shamans'
        Shamans.notCheckable = true
        Shamans.hasArrow = true
        Shamans.value = {
            ['key'] = 'shaman'
        }
        UIDropDownMenu_AddButton(Shamans, UIDROPDOWNMENU_MENU_LEVEL);

        local Paladins = {}
        Paladins.text = TABCA.classColors['paladin'].c .. 'Paladins'
        Paladins.notCheckable = true
        Paladins.hasArrow = true
        Paladins.value = {
            ['key'] = 'paladin'
        }
        UIDropDownMenu_AddButton(Paladins, UIDROPDOWNMENU_MENU_LEVEL);

        local separator = {};
        separator.text = ""
        separator.disabled = true
        UIDropDownMenu_AddButton(separator);

        local clear = {};
        clear.text = "clear"
        clear.disabled = false
        clear.isTitle = false
        clear.notCheckable = true
        clear.func = tabca_changeCell;
        clear.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
        clear.arg2 = 'clear'
        UIDropDownMenu_AddButton(clear, UIDROPDOWNMENU_MENU_LEVEL);

        local close = {};
        close.text = "Close"
        close.disabled = false
        close.notCheckable = true
        close.isTitle = false
        close.func = tabca_closeDropdown
        UIDropDownMenu_AddButton(close, UIDROPDOWNMENU_MENU_LEVEL);
    end
    if UIDROPDOWNMENU_MENU_LEVEL == 2 then

        for _, healer in next, TABCA.raid[UIDROPDOWNMENU_MENU_VALUE['key']] do
            local Healers = {}

            local color = TABCA.classColors[UIDROPDOWNMENU_MENU_VALUE['key']].c

            if TABCA:isPlayerOffline(healer) then
                color = '|cffff0000'
            end

            Healers.text = color .. healer
            Healers.checked = TABCA:markOrPlayerUsed(healer)
            Healers.func = tabca_changeCell
            Healers.arg1 = TABCA.currentRow * 100 + TABCA.currentCell
            Healers.arg2 = healer
            UIDropDownMenu_AddButton(Healers, UIDROPDOWNMENU_MENU_LEVEL);
        end
    end
end

TABCA.currentRow = 0
TABCA.currentCell = 0

function TABCA_Cell_OnClick(id)

    TABCA.currentRow = core.floor(id / 100)
    TABCA.currentCell = id - TABCA.currentRow * 100

    --targets
    if TABCA.currentCell == 1 then
        UIDropDownMenu_Initialize(TABCATargetsDropDown, TABCA_buildTargetsDropdown, "MENU");
        ToggleDropDownMenu(1, nil, TABCATargetsDropDown, "cursor", 2, 3);
    end

    --tanks
    if TABCA.currentCell == 2 or TABCA.currentCell == 3 or TABCA.currentCell == 4 then
        UIDropDownMenu_Initialize(TABCATanksDropDown, TABCA_buildTanksDropdown, "MENU");
        ToggleDropDownMenu(1, nil, TABCATanksDropDown, "cursor", 2, 3);
    end

    --healers
    if TABCA.currentCell == 5 or TABCA.currentCell == 6 or TABCA.currentCell == 7 then
        UIDropDownMenu_Initialize(TABCAHealersDropDown, TABCA_buildHealersDropdown, "MENU");
        ToggleDropDownMenu(1, nil, TABCAHealersDropDown, "cursor", 2, 3);
    end
end

function TABCA_SpamRaid_OnClick()

    ChatThrottleLib:SendChatMessage("BULK", "TABCA", "======= RAID ASSIGNMENTS =======", "RAID")

    for _, data in next, TABCA.data do

        local line = ''
        local dontPrintLine = true
        for i, name in next, data do
            if i > 1 then
                dontPrintLine = dontPrintLine and name == '-'
            end

            local separator = ''
            if i == 1 then
                separator = ' : '
            end
            if i == 4 then
                separator = ' || Healers: '
            end

            if name == '-' then
                name = ''
            end

            if TABCA.loadedTemplate == '4h' then
                if name ~= '' and i >= 5 then
                    name = '[' .. i - 4 .. ']' .. name
                end
            end

            if name == 'Skull' then name = '{skull}' end
            if name == 'Cross' then name = '{cross}' end
            if name == 'Square' then name = '{square}' end
            if name == 'Moon' then name = '{moon}' end
            if name == 'Triangle' then name = '{triangle}' end
            if name == 'Diamond' then name = '{diamond}' end
            if name == 'Circle' then name = '{circle}' end
            if name == 'Star' then name = '{star}' end

            line = line .. name .. ' ' .. separator
        end

        if not dontPrintLine then
            ChatThrottleLib:SendChatMessage("BULK", "TABCA", line, "RAID")
        end
    end
    ChatThrottleLib:SendChatMessage("BULK", "TABCA", "Not assigned, heal the raid. Whisper me 'heal' if you forget your assignment.", "RAID")
end


function TABCA_Reset_OnClick()
    ChatThrottleLib:SendAddonMessage("ALERT", "TABCA", "Reset", "RAID")
end

function TABCA:Reset()
    for index in next, TABCA.data do
        if TABCA.rows[index] then
            TABCA.rows[index]:Hide()
        end
        if TABCA.data[index] then
            TABCA.data[index] = nil
        end
    end
    TABCA.data = {
        [1] = { '-', '-', '-', '-', '-', '-', '-' },
    }
    TABCA:PopulateTABCA()
end

function CloseTABCA_OnClick()
    TABCA_Main:Hide()
end

function toggle_TABCA_Main()
    if TABCA_Main:IsVisible() then
        TABCA_Main:Hide()
    else
        TABCA_Main:Show()
    end
end

function TABCA_buildTemplatesDropdown()
    if UIDROPDOWNMENU_MENU_LEVEL == 1 then

        local Title = {}
        Title.text = "Templates"
        Title.isTitle = true
        UIDropDownMenu_AddButton(Title, UIDROPDOWNMENU_MENU_LEVEL);

        local separator = {};
        separator.text = ""
        separator.disabled = true
        UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

        local Trash = {}
        Trash.text = "Trash"
        Trash.notCheckable = true
        Trash.hasArrow = true
        Trash.value = {
            ['key'] = 'trash'
        }
        UIDropDownMenu_AddButton(Trash, UIDROPDOWNMENU_MENU_LEVEL);

        separator = {};
        separator.text = ""
        separator.disabled = true
        UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

        local Raids = {}

        Raids = {}
        Raids.text = "Naxxramas"
        Raids.notCheckable = true
        Raids.hasArrow = true
        Raids.value = {
            ['key'] = 'naxx'
        }
        UIDropDownMenu_AddButton(Raids, UIDROPDOWNMENU_MENU_LEVEL);

        Raids = {}
        Raids.text = "Eye of Eternity"
        Raids.notCheckable = true
        Raids.hasArrow = true
        Raids.value = {
            ['key'] = 'eye'
        }
        UIDropDownMenu_AddButton(Raids, UIDROPDOWNMENU_MENU_LEVEL);
    end

    if UIDROPDOWNMENU_MENU_LEVEL == 2 then

        if UIDROPDOWNMENU_MENU_VALUE["key"] == 'trash' then

            for i = 1, 5 do
                local dropdownItem = {}
                dropdownItem.text = "Trash #" .. i
                dropdownItem.func = TABCA_loadTemplate_s;
                dropdownItem.arg1 = 'trash' .. i
                UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            end

        end

        if UIDROPDOWNMENU_MENU_VALUE["key"] == 'naxx' then

            local dropdownItem = {}
            dropdownItem.text = "Anub'rekhan"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'anub'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            dropdownItem = {}
            dropdownItem.text = "Faerlina"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'faerlina'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            dropdownItem = {}
            dropdownItem.text = "Maexxna"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'maexxna'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            local separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            dropdownItem = {}
            dropdownItem.text = "Noth"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'noth'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            dropdownItem = {}
            dropdownItem.text = "Heigan"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'heigan'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            dropdownItem = {}
            dropdownItem.text = "Loatheb"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'loatheb'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            dropdownItem = {}
            dropdownItem.text = "Razuvious"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'raz'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            dropdownItem = {}
            dropdownItem.text = "Gothik"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'gothik'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            dropdownItem = {}
            dropdownItem.text = "Four Horsemen"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = '4h'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            dropdownItem = {}
            dropdownItem.text = "Patchwerk"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'patchwerk'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            dropdownItem = {}
            dropdownItem.text = "Grobbulus"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'grobulus'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            dropdownItem = {}
            dropdownItem.text = "Gluth"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'gluth'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            dropdownItem = {}
            dropdownItem.text = "Thaddius"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'thaddius'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            separator = {};
            separator.text = ""
            separator.disabled = true
            UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL);

            dropdownItem = {}
            dropdownItem.text = "Sapphiron"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'saph'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

            dropdownItem = {}
            dropdownItem.text = "Kel'Thuzad"
            dropdownItem.func = TABCA_loadTemplate_s;
            dropdownItem.arg1 = 'kt'
            UIDropDownMenu_AddButton(dropdownItem, UIDROPDOWNMENU_MENU_LEVEL);
            dropdownItem = nil

        end
    end
end

function TABCA_Templates_OnClick()
    UIDropDownMenu_Initialize(TABCATemplates, TABCA_buildTemplatesDropdown, "MENU");
    ToggleDropDownMenu(1, nil, TABCATemplates, "cursor", 2, 3);
end

function TABCA_LoadPreset_OnClick()

    if TABCA.loadedTemplate == '' then
        twaprint('Please load a template first.')
    else

        TABCA_loadTemplate(TABCA.loadedTemplate)

        if TABCA_PRESETS[TABCA.loadedTemplate] then
            for index, data in next, TABCA_PRESETS[TABCA.loadedTemplate] do
                for i, name in data do
                    if i ~= 1 and name ~= '-' then
                        TABCA:changeCell(index * 100 + i, name, true)
                    end
                end
            end
        else
            twaprint('No preset saved for |cff69ccf0' .. TABCA.loadedTemplate)
        end
    end
end

function TABCA_SavePreset_OnClick()

    if TABCA.loadedTemplate == '' then
        twaprint('Please load a template first.')
    else
        local preset = {}
        for index, data in next, TABCA.data do
            preset[index] = {}
            for _, name in data do
                core.insert(preset[index], name)
            end
        end
        TABCA_PRESETS[TABCA.loadedTemplate] = preset
        twaprint('Saved preset for |cff69ccf0' .. TABCA.loadedTemplate)
    end

end



function pairsByKeys(t, f)
    local a = {}
    for n in core.pairs(t) do
        core.insert(a, n)
    end
    core.sort(a, function(a, b)
        return a < b
    end)
    local i = 0 -- iterator variable
    local iter = function()
        -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end
