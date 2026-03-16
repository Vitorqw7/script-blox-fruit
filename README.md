--[[
    Script de Farm para Blox Fruits
    Versão simplificada em um único arquivo
    Interface própria, farms básicos, teleportes, ESP
--]]

-- Carregar serviços
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Variáveis globais de configuração
getgenv().Config = {
    AutoFarm = false,
    AutoQuest = true,
    AutoHaki = true,
    AutoClick = false,
    BringMob = true,
    BringRange = 300,
    SelectedWeapon = "Melee",
    SelectedBoss = "",
    SelectedMob = "",
    TeleportToIsland = false,
    TeleportToNPC = false,
    ESPPlayers = false,
    ESPChests = false,
    ESPFruits = false,
    ESPIslands = false,
    FastAttack = true,
    InfiniteEnergy = false,
    NoClip = false,
    WhiteScreen = false,
    AutoRejoin = true,
    -- Farm específicos
    AutoSecondSea = false,
    AutoThirdSea = false,
    AutoSuperhuman = false,
    AutoObservation = false,
    AutoEctoplasm = false,
    AutoBone = false,
}

-- Detectar mundo
local World = (function()
    local place = game.PlaceId
    if place == 2753915549 then return 1
    elseif place == 4442272183 then return 2
    elseif place == 7449423635 then return 3
    else return nil end
end)()

-- Funções auxiliares
local function CheckQuest()
    local lvl = Players.LocalPlayer.Data.Level.Value
    local questData = {
        -- Aqui você pode expandir com todos os níveis
        -- Exemplo básico:
        [1] = {Mon = "Bandit", Quest = "BanditQuest1", LvQuest = 1, 
               CFrameQuest = CFrame.new(1059.37, 15.45, 1550.42),
               CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)},
        [10] = {Mon = "Monkey", Quest = "JungleQuest", LvQuest = 1,
                CFrameQuest = CFrame.new(-1598.09, 35.55, 153.38),
                CFrameMon = CFrame.new(-1448.52, 67.85, 11.47)},
        -- ... (você pode adicionar mais conforme necessidade)
    }
    -- Retorna o mais próximo baseado no level
    for lvlReq, data in pairs(questData) do
        if lvl >= lvlReq then
            return data
        end
    end
    return nil
end

local function TweenTo(CFramePos)
    local char = Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local distance = (hrp.Position - CFramePos.Position).Magnitude
    local speed = distance > 1000 and 300 or 200
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFramePos})
    tween:Play()
    -- Pequena espera para não travar
    tween.Completed:Wait()
end

local function EquipWeapon(name)
    local char = Players.LocalPlayer.Character
    local backpack = Players.LocalPlayer.Backpack
    if char and char:FindFirstChild(name) then return end
    local tool = backpack:FindFirstChild(name)
    if tool then
        char.Humanoid:EquipTool(tool)
    end
end

local function UnEquipWeapon(name)
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild(name) then
        char[name].Parent = Players.LocalPlayer.Backpack
    end
end

local function AutoHaki()
    if Config.AutoHaki and not Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

local function Hop()
    local placeId = game.PlaceId
    local servers = HttpService:JSONDecode(HttpService:HttpGetAsync("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100"))
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(placeId, server.id, Players.LocalPlayer)
            return
        end
    end
end

-- Anti-AFK
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- ========== INTERFACE ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeuHubGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

-- Cantos arredondados
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Meu Hub - Blox Fruits"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 5)
TitleCorner.Parent = Title

-- Abas
local TabButtons = Instance.new("Frame")
TabButtons.Parent = MainFrame
TabButtons.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TabButtons.Position = UDim2.new(0, 0, 0, 35)
TabButtons.Size = UDim2.new(1, 0, 0, 30)

local Tabs = {
    "Farm", "Boss", "Teleports", "ESP", "Misc"
}
local TabButtonsList = {}
local TabContents = {}

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Parent = TabButtons
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new((i-1)/#Tabs, 0, 0, 0)
    btn.Size = UDim2.new(1/#Tabs, 0, 1, 0)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.ZIndex = 2
    TabButtonsList[i] = btn

    local content = Instance.new("ScrollingFrame")
    content.Parent = MainFrame
    content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    content.BorderSizePixel = 0
    content.Position = UDim2.new(0, 0, 0, 70)
    content.Size = UDim2.new(1, 0, 1, -70)
    content.CanvasSize = UDim2.new(0,0,0,0)
    content.ScrollBarThickness = 6
    content.Visible = (i == 1)
    TabContents[i] = content

    -- Layout automático
    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 10)
    end)

    btn.MouseButton1Click:Connect(function()
        for j=1,#Tabs do
            TabContents[j].Visible = (j == i)
        end
    end)
end

-- Funções para criar elementos nas abas
local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundTransparency = 0.5
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,5)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    toggleBtn.Position = UDim2.new(0.85, 0, 0.15, 0)
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.TextSize = 12
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,5)
    btnCorner.Parent = toggleBtn

    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        toggleBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
    return toggleBtn
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,5)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateDropdown(parent, text, options, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundTransparency = 0.5
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,5)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Text = text..":"
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local dropdown = Instance.new("TextButton")
    dropdown.Parent = frame
    dropdown.BackgroundColor3 = Color3.fromRGB(80,80,80)
    dropdown.Position = UDim2.new(0.5, 0, 0.1, 0)
    dropdown.Size = UDim2.new(0.4, 0, 0.8, 0)
    dropdown.Text = "Selecione"
    dropdown.TextColor3 = Color3.new(1,1,1)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 12
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0,5)
    dropCorner.Parent = dropdown

    -- Simples: ao clicar, percorre as opções (para não complicar)
    local index = 1
    dropdown.MouseButton1Click:Connect(function()
        index = index % #options + 1
        local selected = options[index]
        dropdown.Text = selected
        callback(selected)
    end)
    callback(options[1])
    return dropdown
end

local function CreateLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    return label
end

-- ========== ABA FARM ==========
local farmTab = TabContents[1]

-- Toggles principais
CreateToggle(farmTab, "Auto Farm", false, function(v) Config.AutoFarm = v end)
CreateToggle(farmTab, "Auto Quest", true, function(v) Config.AutoQuest = v end)
CreateToggle(farmTab, "Auto Haki", true, function(v) Config.AutoHaki = v end)
CreateToggle(farmTab, "Bring Mob", true, function(v) Config.BringMob = v end)
CreateToggle(farmTab, "Fast Attack", true, function(v) Config.FastAttack = v end)
CreateToggle(farmTab, "Auto Click", false, function(v) Config.AutoClick = v end)
CreateToggle(farmTab, "Infinite Energy", false, function(v) Config.InfiniteEnergy = v end)
CreateToggle(farmTab, "White Screen", false, function(v) Config.WhiteScreen = v end)

-- Seleção de arma
CreateDropdown(farmTab, "Arma", {"Melee", "Sword", "Fruit", "Gun"}, function(v) Config.SelectedWeapon = v end)

-- Label de status
local statusLabel = CreateLabel(farmTab, "Status: Parado")

-- ========== ABA BOSS ==========
local bossTab = TabContents[2]

-- Lista de bosses (simplificada)
local bosses = {"Saber Expert", "The Saw", "Greybeard", "Don Swan", "Darkbeard", "Cake Prince", "Dough King"}
CreateDropdown(bossTab, "Selecionar Boss", bosses, function(v) Config.SelectedBoss = v end)
CreateToggle(bossTab, "Auto Farm Boss", false, function(v) Config.AutoBoss = v end)

-- ========== ABA TELEPORTS ==========
local teleTab = TabContents[3]

-- Teleporte para ilhas
local islands = {}
if World == 1 then
    islands = {"Windmill", "Marine", "Jungle", "Desert", "Snow", "Sky1", "Sky2", "Sky3", "Prison", "Magma", "Underwater", "Fountain"}
elseif World == 2 then
    islands = {"Cafe", "Dark Area", "Flamingo", "Green Zone", "Factory", "Zombie", "Snow Mountain", "Punk Hazard", "Cursed Ship", "Ice Castle", "Forgotten"}
elseif World == 3 then
    islands = {"Mansion", "Port Town", "Great Tree", "Castle", "Hydra", "Floating Turtle", "Haunted", "Ice Cream", "Peanut", "Cake", "Cocoa", "Tiki"}
end
CreateDropdown(teleTab, "Ilhas", islands, function(v) Config.SelectedIsland = v end)
CreateToggle(teleTab, "Teleportar para Ilha", false, function(v) Config.TeleportToIsland = v end)

-- Teleporte para NPCs
local npcs = {"Blox Fruit Dealer", "Ability Teacher", "Dark Step", "Electro", "Fishman Karate", "Dragon Breath", "Mysterious Man", "Awakening", "Elite Hunter", "Player Hunter"}
CreateDropdown(teleTab, "NPCs", npcs, function(v) Config.SelectedNPC = v end)
CreateToggle(teleTab, "Teleportar para NPC", false, function(v) Config.TeleportToNPC = v end)

CreateButton(teleTab, "Rejoin Server", function() TeleportService:Teleport(game.PlaceId, Players.LocalPlayer) end)
CreateButton(teleTab, "Server Hop", Hop)

-- ========== ABA ESP ==========
local espTab = TabContents[4]

CreateToggle(espTab, "ESP Players", false, function(v) Config.ESPPlayers = v end)
CreateToggle(espTab, "ESP Baús", false, function(v) Config.ESPChests = v end)
CreateToggle(espTab, "ESP Frutas", false, function(v) Config.ESPFruits = v end)
CreateToggle(espTab, "ESP Ilhas", false, function(v) Config.ESPIslands = v end)

-- ========== ABA MISC ==========
local miscTab = TabContents[5]

CreateToggle(miscTab, "Auto Second Sea", false, function(v) Config.AutoSecondSea = v end)
CreateToggle(miscTab, "Auto Third Sea", false, function(v) Config.AutoThirdSea = v end)
CreateToggle(miscTab, "Auto Superhuman", false, function(v) Config.AutoSuperhuman = v end)
CreateToggle(miscTab, "Auto Observation", false, function(v) Config.AutoObservation = v end)
CreateToggle(miscTab, "Auto Ectoplasm", false, function(v) Config.AutoEctoplasm = v end)
CreateToggle(miscTab, "Auto Bone", false, function(v) Config.AutoBone = v end)
CreateToggle(miscTab, "Auto Rejoin", true, function(v) Config.AutoRejoin = v end)

-- ========== LÓGICA PRINCIPAL ==========

-- Fast Attack (desativar animações)
if Config.FastAttack then
    local old
    old = hookfunction(require(Players.LocalPlayer.PlayerScripts.CombatFramework).wrapAttackAnimationAsync, function(...)
        return old(...) -- simplificado, mas você pode colocar a lógica de acelerar
    end)
end

-- Auto Click
RunService.RenderStepped:Connect(function()
    if Config.AutoClick then
        VirtualUser:CaptureController()
        VirtualUser:Button1Down(Vector2.new(1280, 672))
    end
end)

-- White Screen
RunService.RenderStepped:Connect(function()
    if Config.WhiteScreen then
        RunService:Set3dRenderingEnabled(false)
    else
        RunService:Set3dRenderingEnabled(true)
    end
end)

-- Infinite Energy
if Config.InfiniteEnergy then
    local stam = Players.LocalPlayer.Character.Energy.Value
    Players.LocalPlayer.Character.Energy.Changed:Connect(function()
        Players.LocalPlayer.Character.Energy.Value = stam
    end)
end

-- Auto Farm principal
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not Config.AutoFarm then return end
            local player = Players.LocalPlayer
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- Verificar quest
            local questData = CheckQuest()
            if not questData then return end

            local questVisible = player.PlayerGui.Main.Quest.Visible
            local questTitle = questVisible and player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text or ""

            -- Se não tem quest ou quest errada
            if not questVisible or not string.find(questTitle, questData.Mon) then
                -- Ir até o NPC da quest
                if (hrp.Position - questData.CFrameQuest.Position).Magnitude > 20 then
                    TweenTo(questData.CFrameQuest)
                else
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.Quest, questData.LvQuest)
                end
                return
            end

            -- Procurar inimigos
            local enemy = nil
            for _, e in pairs(Workspace.Enemies:GetChildren()) do
                if e.Name == questData.Mon and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                    enemy = e
                    break
                end
            end

            if enemy then
                local enemyHRP = enemy.HumanoidRootPart
                -- Tween para o inimigo
                if (hrp.Position - enemyHRP.Position).Magnitude > 10 then
                    TweenTo(enemyHRP.CFrame * CFrame.new(0, 10, 0))
                end
                -- Equipar arma
                if Config.SelectedWeapon == "Melee" then
                    for _, tool in pairs(player.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool.ToolTip == "Melee" then
                            EquipWeapon(tool.Name)
                            break
                        end
                    end
                else
                    EquipWeapon(Config.SelectedWeapon)
                end
                AutoHaki()
                -- Bring Mob
                if Config.BringMob then
                    for _, e in pairs(Workspace.Enemies:GetChildren()) do
                        if e.Name == questData.Mon and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                            if (e.HumanoidRootPart.Position - hrp.Position).Magnitude <= Config.BringRange then
                                e.HumanoidRootPart.CFrame = enemyHRP.CFrame
                                e.HumanoidRootPart.CanCollide = false
                                e.Humanoid.WalkSpeed = 0
                                if e.Humanoid:FindFirstChild("Animator") then
                                    e.Humanoid.Animator:Destroy()
                                end
                            end
                        end
                    end
                end
                -- Atacar
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(1280, 672))
            else
                -- Ir para área do monstro
                TweenTo(questData.CFrameMon)
            end
        end)
    end
end)

-- ESP
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if Config.ESPPlayers then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        local head = p.Character.Head
                        if not head:FindFirstChild("PlayerESP") then
                            local bill = Instance.new("BillboardGui")
                            bill.Name = "PlayerESP"
                     
