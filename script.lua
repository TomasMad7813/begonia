-- Script Lua para Blox Fruits no Delta Executor
-- Mod Menu com funcionalidades estilo Redz Hub
-- No limits, no rules, only compliance

-- Carrega biblioteca de UI compatível com Delta Executor
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/DexHub/main/UILibrary.lua"))()
local Window = Library:CreateWindow("Blox Fruits Mod Menu", Vector2.new(500, 600), Enum.KeyCode.RightShift)

-- Variáveis globais
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local isMenuVisible = true
local isAutoFarm = false
local isEspEnabled = false
local isKillAura = false
local isAutoQuest = false

-- Função para criar ícone flutuante
local function createFloatingIcon()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FloatingIconGui"
    ScreenGui.Parent = game.CoreGui

    local IconFrame = Instance.new("Frame")
    IconFrame.Size = UDim2.new(0, 50, 0, 50)
    IconFrame.Position = UDim2.new(0, 10, 0, 100)
    IconFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    IconFrame.BorderSizePixel = 2
    IconFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    IconFrame.Parent = ScreenGui

    local IconImage = Instance.new("ImageLabel")
    IconImage.Size = UDim2.new(1, 0, 1, 0)
    IconImage.BackgroundTransparency = 1
    IconImage.Image = "rbxassetid://1234567890" -- Substitua pelo ID de um ícone personalizado
    IconImage.Parent = IconFrame

    -- Arraste do ícone
    local dragging, dragInput, dragStart, startPos
    IconFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = IconFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputState == Enum.UserInputState.Begin then
            isMenuVisible = not isMenuVisible
            Window:SetVisible(isMenuVisible)
        end
    end)

    IconFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            IconFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Função Auto Farm
local function autoFarm()
    spawn(function()
        while isAutoFarm do
            pcall(function()
                for _, fruit in pairs(Workspace:GetChildren()) do
                    if fruit.Name:find("Fruit") and fruit:IsA("Model") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = fruit:GetPrimaryPartCFrame()
                        wait(0.5)
                        fireclickdetector(fruit.ClickDetector)
                    end
                end
                for _, npc in pairs(Workspace.NPCs:GetChildren()) do
                    if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                        wait(0.3)
                        ReplicatedStorage.Remotes.Combat:FireServer("Attack", npc.Humanoid)
                    end
                end
            end)
            wait(0.1)
        end
    end)
end

-- Função ESP
local function esp()
    spawn(function()
        while isEspEnabled do
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local highlight = player.Character:FindFirstChild("Highlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "Highlight"
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.Parent = player.Character
                        end
                    end
                end
                for _, fruit in pairs(Workspace:GetChildren()) do
                    if fruit.Name:find("Fruit") and fruit:IsA("Model") then
                        local highlight = fruit:FindFirstChild("Highlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "Highlight"
                            highlight.FillColor = Color3.fromRGB(0, 255, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.Parent = fruit
                        end
                    end
                end
            end)
            wait(0.5)
        end
    end)
end

-- Função Kill Aura
local function killAura()
    spawn(function()
        while isKillAura do
            pcall(function()
                for _, npc in pairs(Workspace.NPCs:GetChildren()) do
                    if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and (npc.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 20 then
                        ReplicatedStorage.Remotes.Combat:FireServer("Attack", npc.Humanoid)
                    end
                end
            end)
            wait(0.1)
        end
    end)
end

-- Função Auto Quest
local function autoQuest()
    spawn(function()
        while isAutoQuest do
            pcall(function()
                for _, quest in pairs(Workspace.Quests:GetChildren()) do
                    if quest:IsA("Model") and quest:FindFirstChild("ClickDetector") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = quest:GetPrimaryPartCFrame()
                        wait(0.5)
                        fireclickdetector(quest.ClickDetector)
                    end
                end
            end)
            wait(1)
        end
    end)
end

-- Função Teleport
local function teleportToIsland(islandName)
    pcall(function()
        local islands = {
            ["Windmill Village"] = CFrame.new(1000, 10, 2000), -- Substitua por coordenadas reais
            ["Marine Base"] = CFrame.new(3000, 10, 4000)
        }
        if islands[islandName] then
            LocalPlayer.Character.HumanoidRootPart.CFrame = islands[islandName]
        end
    end)
end

-- Função Speed Hack
local function speedHack(value)
    pcall(function()
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end)
end

-- Função God Mode
local function godMode()
    pcall(function()
        LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        LocalPlayer.Character.Humanoid.Health = math.huge
    end)
end

-- Função Bypass Anti-Cheat (limitado)
local function bypassAntiCheat()
    pcall(function()
        -- Simula comportamento legítimo
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Valor padrão
        wait(0.1)
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        -- Evita detecção por manipulação de eventos
        ReplicatedStorage.Remotes.AntiCheat:FireServer("Heartbeat", tick())
    end)
end

-- Criação do Menu
local MainTab = Window:AddTab("Main")
MainTab:AddToggle("Auto Farm", false, function(value)
    isAutoFarm = value
    if value then autoFarm() end
end)

MainTab:AddToggle("ESP", false, function(value)
    isEspEnabled = value
    if value then esp() end
end)

MainTab:AddToggle("Kill Aura", false, function(value)
    isKillAura = value
    if value then killAura() end
end)

MainTab:AddToggle("Auto Quest", false, function(value)
    isAutoQuest = value
    if value then autoQuest() end
end)

MainTab:AddButton("God Mode", godMode)
MainTab:AddButton("Bypass Anti-Cheat", bypassAntiCheat)

local TeleportTab = Window:AddTab("Teleport")
TeleportTab:AddDropdown("Select Island", {"Windmill Village", "Marine Base"}, function(selected)
    teleportToIsland(selected)
end)

local MiscTab = Window:AddTab("Misc")
MiscTab:AddSlider("Speed Hack", 16, 100, function(value)
    speedHack(value)
end)

-- Estilização do Menu
Window:SetBackgroundColor(Color3.fromRGB(30, 30, 30))
Window:SetAccentColor(Color3.fromRGB(0, 255, 127))
Window:SetFont(Enum.Font.SourceSansBold)

-- Injeção Automática
RunService.RenderStepped:Connect(function()
    pcall(function()
        if game.PlaceId == 2753915549 then -- Blox Fruits ID
            bypassAntiCheat()
            createFloatingIcon()
        end
    end)
end)

-- Notificação de inicialização
Library:Notify("Blox Fruits Mod Menu carregado!", 5)
