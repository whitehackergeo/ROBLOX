local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "White Hacker Loader",
    Author = "White Hacker Team",
    Icon = "search",
    Theme = "Dark",
    Size = UDim2.fromOffset(500, 450),
    Transparent = true
})

local LoaderTab = Window:Tab({ Title = "Script Search", Icon = "search" })

-- ============ DATABASE ============
local ScriptDatabase = {
    {
        Name = "Wall Jumps For Brainrot",
        Url = "https://raw.githubusercontent.com/whitehackergeo/ROBLOX/refs/heads/main/Wall-Jumps-For-Brainrot/Script.lua",
        Icon = "zap",
        Desc = "Auto Farm Money & Wins"
    },
    -- Add more scripts here
}

-- ============ LOGIC ============
local ActiveElements = {}

local function ClearResults()
    for _, element in pairs(ActiveElements) do
        pcall(function() element:Destroy() end)
    end
    ActiveElements = {}
end

local function ShowScripts(filterText)
    ClearResults()
    local query = string.lower(filterText)
    
    for _, data in pairs(ScriptDatabase) do
        if filterText == "" or string.find(string.lower(data.Name), query) then
            local btn = LoaderTab:Button({
                Title = data.Name,
                Desc = data.Desc,
                Icon = data.Icon,
                Callback = function()
                    Window:Close()
                    task.spawn(function()
                        loadstring(game:HttpGet(data.Url))()
                    end)
                end
            })
            table.insert(ActiveElements, btn)
        end
    end
end

-- ============ UI SETUP ============
local SearchInput = LoaderTab:Input({
    Title = "Search Scripts",
    Placeholder = "Type and press ENTER...",
    Callback = function(text, enterPressed)
        -- Library-level Enter check
        if enterPressed then
            ShowScripts(text)
        end
    end
})

-- MANUAL FIX: Ensure it ONLY triggers on Enter
task.spawn(function()
    task.wait(0.5)
    local textBox = nil
    pcall(function()
        -- Direct path to the TextBox in WindUI structure
        textBox = SearchInput.Frame.Frame.TextBox 
    end)

    if textBox then
        -- Clear library callback and use direct FocusLost
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                ShowScripts(textBox.Text)
            end
        end)
    end
end)

LoaderTab:Divider()
ShowScripts("") -- Show all by default
