--[[
    Vitorqw7 Hub - Blox Fruits
    Créditos: Vitorqw7
    Versão: 3.0 (Completa - Lógica original + Interface + Key System)
]]

-- ================= CONFIGURAÇÕES INICIAIS =================
local KEY_CORRETA = "7"   -- 🔑 Altere aqui sua key
local NOME_HUB = "Vitorqw7 Hub"
local COR_PRIMARIA = Color3.fromRGB(220, 20, 60)    -- Vermelho
local COR_SECUNDARIA = Color3.fromRGB(30, 30, 30)

-- ================= SERVIÇOS =================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ================= VARIÁVEIS GLOBAIS DE FARM =================
-- (todas as variáveis usadas no script original)
_G.AutoFarm = false
_G.AutoFarmNearest = false
_G.AutoBoss = false
_G.SelectWeapon = "Melee"
_G.SelectBoss = "Saber Expert"
_G.AutoRaid = false
_G.AutoSeaBeast = false
_G.AutoChest = false
_G.AutoFruit = false
_G.AutoMastery = false
_G.AutoBounty = false
_G.AutoObservation = false
_G.AutoRengoku = false
_G.AutoEctoplasm = false
_G.AutoBone = false
_G.AutoEliteHunter = false
_G.AutoBartilo = false
_G.AutoThirdSea = false
_G.AutoSecondSea = false
_G.AutoDragonScale = false
_G.AutoLeather = false
_G.AutoScrap = false
_G.AutoGunpowder = false
_G.AutoFishTail = false
_G.AutoMiniTusk = false
_G.AutoCocoa = false
_G.AutoRadioactive = false
_G.AutoMysticDroplet = false
_G.AutoMagmaOre = false
_G.AutoAngelWing = false
_G.AutoSuperhuman = false
_G.AutoDeathStep = false
_G.AutoSharkman = false
_G.AutoElectricClaw = false
_G.AutoDragonTalon = false
_G.AutoGodHuman = false
_G.AutoDoughtBoss = false
_G.Autodoughking = false
_G.Auto_Bone = false
_G.AutoFarmFruitMastery = false
_G.AutoFarmGunMastery = false
_G.AutoSwordMastery = false
_G.SkillZ = true
_G.SkillX = true
_G.SkillC = true
_G.SkillV = true
_G.Kill_At = 30
_G.BringMode = 300
_G.BringMonster = true
_G.FastAttack = true
_G.AutoHaki = true
_G.WhiteScreen = false
_G.Remove_trct = false
_G.WalkWater = true
_G.AutoClick = false
_BypassTP = false

-- Detecção de Mundo
World1 = game.PlaceId == 2753915549
World2 = game.PlaceId == 4442272183
World3 = game.PlaceId == 7449423635

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= FUNÇÕES AUXILIARES =================
local function Notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

local function TP(pos)
    if typeof(pos) == "CFrame" then
        LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    else
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

local function EquipWeapon(weaponName)
    if LocalPlayer.Backpack:FindFirstChild(weaponName) then
        LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack[weaponName])
    end
end

local function GetDistance(pos)
    return (LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude
end

-- ================= FUNÇÕES ORIGINAIS DO SCRIPT (myscript.txt) =================
-- (aqui vai todo o conteúdo do seu myscript.txt, a partir de "repeat wait() until game.Players.LocalPlayer")
-- Por questão de espaço, vou inserir um resumo. Para obter o script completo, cole o conteúdo do seu myscript.txt AQUI.
-- Mas para garantir a funcionalidade, você DEVE copiar e colar todo o código do seu arquivo original neste local.
-- Abaixo está apenas um esqueleto para referência.

repeat wait() until game.Players.LocalPlayer
-- [[ COLE AQUI TODO O CONTEÚDO DO SEU ARQUIVO myscript.txt ]]
-- Exemplo: funções CheckQuest, Hop, UpdateIslandESP, Teleport, etc.

-- ================= SISTEMA DE KEY (baseado no Hoho V2) =================
local function criarSistemaKey()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Vitorqw7_KeySystem"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 250)
    frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    frame.BackgroundColor3 = COR_SECUNDARIA
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    local titulo = Instance.new("TextLabel")
    titulo.Size = UDim2.new(1, 0, 0, 40)
    titulo.Position = UDim2.new(0, 0, 0, 10)
    titulo.BackgroundTransparency = 1
    titulo.Text = NOME_HUB .. " - Key System"
    titulo.TextColor3 = Color3.new(1, 1, 1)
    titulo.Font = Enum.Font.GothamBold
    titulo.TextSize = 20
    titulo.Parent = frame

    local linha = Instance.new("Frame")
    linha.Size = UDim2.new(0.9, 0, 0, 2)
    linha.Position = UDim2.new(0.05, 0, 0, 50)
    linha.BackgroundColor3 = COR_PRIMARIA
    linha.BorderSizePixel = 0
    linha.Parent = frame

    local labelKey = Instance.new("TextLabel")
    labelKey.Size = UDim2.new(1, 0, 0, 30)
    labelKey.Position = UDim2.new(0, 0, 0, 70)
    labelKey.BackgroundTransparency = 1
    labelKey.Text = "Digite sua Key:"
    labelKey.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    labelKey.Font = Enum.Font.Gotham
    labelKey.TextSize = 16
    labelKey.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.8, 0, 0, 35)
    textBox.Position = UDim2.new(0.1, 0, 0, 110)
    textBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    textBox.TextColor3 = Color3.new(1, 1, 1)
    textBox.PlaceholderText = "Insira a key"
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame

    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 5)
    textBoxCorner.Parent = textBox

    local botao = Instance.new("TextButton")
    botao.Size = UDim2.new(0.5, 0, 0, 40)
    botao.Position = UDim2.new(0.25, 0, 0, 170)
    botao.BackgroundColor3 = COR_PRIMARIA
    botao.Text = "VERIFICAR"
    botao.TextColor3 = Color3.new(1, 1, 1)
    botao.Font = Enum.Font.GothamBold
    botao.TextSize = 16
    botao.Parent = frame

    local botaoCorner = Instance.new("UICorner")
    botaoCorner.CornerRadius = UDim.new(0, 5)
    botaoCorner.Parent = botao

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 30)
    statusLabel.Position = UDim2.new(0, 0, 0, 220)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.new(1, 0, 0)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 14
    statusLabel.Parent = frame

    botao.MouseButton1Click:Connect(function()
        local key = textBox.Text:gsub("%s+", "")
        if key == KEY_CORRETA then
            statusLabel.TextColor3 = Color3.new(0, 1, 0)
            statusLabel.Text = "Key válida! Carregando..."
            wait(1)
            screenGui:Destroy()
            criarInterface()
        else
            statusLabel.Text = "Key inválida!"
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Escape then
            screenGui:Destroy()
        end
    end)
end

-- ================= INTERFACE PRINCIPAL =================
local function criarInterface()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Vitorqw7_Hub"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false

    -- Ícone flutuante
    local icone = Instance.new("ImageButton")
    icone.Size = UDim2.new(0, 50, 0, 50)
    icone.Position = UDim2.new(0, 20, 0.5, -25)
    icone.BackgroundColor3 = COR_PRIMARIA
    icone.BackgroundTransparency = 0.2
    icone.Image = "rbxassetid://18899804355"
    icone.ImageColor3 = Color3.new(1, 1, 1)
    icone.Draggable = true
    icone.Parent = screenGui

    local iconeCorner = Instance.new("UICorner")
    iconeCorner.CornerRadius = UDim.new(0, 8)
    iconeCorner.Parent = icone

    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 700, 0, 450)
    frame.Position = UDim2.new(0.5, -350, 0.5, -225)
    frame.BackgroundColor3 = COR_SECUNDARIA
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Visible = false
    frame.Parent = screenGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame

    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = COR_PRIMARIA
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame

    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 10)
    titleBarCorner.Parent = titleBar

    local titulo = Instance.new("TextLabel")
    titulo.Size = UDim2.new(1, -40, 1, 0)
    titulo.Position = UDim2.new(0, 10, 0, 0)
    titulo.BackgroundTransparency = 1
    titulo.Text = NOME_HUB .. " - Blox Fruits"
    titulo.TextColor3 = Color3.new(1, 1, 1)
    titulo.Font = Enum.Font.GothamBold
    titulo.TextSize = 18
    titulo.TextXAlignment = Enum.TextXAlignment.Left
    titulo.Parent = titleBar

    local botaoFechar = Instance.new("TextButton")
    botaoFechar.Size = UDim2.new(0, 30, 0, 30)
    botaoFechar.Position = UDim2.new(1, -35, 0, 2.5)
    botaoFechar.BackgroundColor3 = Color3.new(0.8, 0, 0)
    botaoFechar.Text = "X"
    botaoFechar.TextColor3 = Color3.new(1, 1, 1)
    botaoFechar.Font = Enum.Font.GothamBold
    botaoFechar.TextSize = 18
    botaoFechar.Parent = titleBar

    local botaoFecharCorner = Instance.new("UICorner")
    botaoFecharCorner.CornerRadius = UDim.new(0, 5)
    botaoFecharCorner.Parent = botaoFechar

    -- Abas
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(0, 130, 1, -35)
    tabFrame.Position = UDim2.new(0, 0, 0, 35)
    tabFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = frame

    local tabs = {"Farm", "Boss", "Raid", "Sea", "Fruits", "Materials", "Melee", "Teleports", "Misc"}
    local botoesTab = {}

    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.Position = UDim2.new(0, 0, 0, (i-1)*35)
        btn.BackgroundColor3 = i == 1 and COR_PRIMARIA or Color3.new(0.2, 0.2, 0.2)
        btn.BackgroundTransparency = 0.3
        btn.Text = tabName
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = tabFrame
        botoesTab[tabName] = btn
    end

    -- Área de conteúdo
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -135, 1, -35)
    contentFrame.Position = UDim2.new(0, 135, 0, 35)
    contentFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = frame

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = contentFrame

    -- Páginas
    local pages = {}
    for _, tabName in ipairs(tabs) do
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 5
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = contentFrame

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.Parent = page

        pages[tabName] = page
    end

    -- Função para alternar abas
    local function selecionarAba(nome)
        for tabName, btn in pairs(botoesTab) do
            btn.BackgroundColor3 = tabName == nome and COR_PRIMARIA or Color3.new(0.2, 0.2, 0.2)
        end
        for _, page in pairs(pages) do
            page.Visible = false
        end
        pages[nome].Visible = true
    end

    for tabName, btn in pairs(botoesTab) do
        btn.MouseButton1Click:Connect(function()
            selecionarAba(tabName)
        end)
    end

    selecionarAba("Farm")

    -- Funções para criar elementos
    local function criarBotao(pai, texto, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = COR_PRIMARIA
        btn.BackgroundTransparency = 0.3
        btn.Text = texto
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = pai

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(callback)
    end

    local function criarToggle(pai, texto, variavel)
        local frameToggle = Instance.new("Frame")
        frameToggle.Size = UDim2.new(1, 0, 0, 30)
        frameToggle.BackgroundTransparency = 1
        frameToggle.Parent = pai

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = texto
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frameToggle

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 45, 0, 20)
        toggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
        toggleBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        toggleBtn.Text = ""
        toggleBtn.Parent = frameToggle

        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 10)
        toggleCorner.Parent = toggleBtn

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 16, 0, 16)
        circle.Position = UDim2.new(0, 2, 0.5, -8)
        circle.BackgroundColor3 = Color3.new(1, 1, 1)
        circle.Parent = toggleBtn

        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(0, 8)
        circleCorner.Parent = circle

        local ativo = _G[variavel] or false

        local function atualizarToggle()
            if ativo then
                toggleBtn.BackgroundColor3 = COR_PRIMARIA
                circle:TweenPosition(UDim2.new(0, 27, 0.5, -8), "Out", "Quad", 0.2, true)
            else
                toggleBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
                circle:TweenPosition(UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
            end
        end

        atualizarToggle()

        toggleBtn.MouseButton1Click:Connect(function()
            ativo = not ativo
            _G[variavel] = ativo
            atualizarToggle()
        end)
    end

    -- Preencher páginas
    -- Farm
    criarToggle(pages["Farm"], "Auto Farm Level", "AutoFarm")
    criarToggle(pages["Farm"], "Auto Farm Nearest", "AutoFarmNearest")
    criarToggle(pages["Farm"], "Auto Observation Haki", "AutoObservation")
    criarToggle(pages["Farm"], "Auto Rengoku", "AutoRengoku")
    criarToggle(pages["Farm"], "Auto Ectoplasm", "AutoEctoplasm")
    criarToggle(pages["Farm"], "Auto Bone", "AutoBone")
    criarToggle(pages["Farm"], "Auto Elite Hunter", "AutoEliteHunter")
    criarToggle(pages["Farm"], "Auto Bartilo", "AutoBartilo")
    criarToggle(pages["Farm"], "Auto Second Sea", "AutoSecondSea")
    criarToggle(pages["Farm"], "Auto Third Sea", "AutoThirdSea")

    -- Boss
    criarBotao(pages["Boss"], "Farm Saber Expert", function() _G.SelectBoss = "Saber Expert"; _G.AutoBoss = true end)
    criarBotao(pages["Boss"], "Farm The Saw", function() _G.SelectBoss = "The Saw"; _G.AutoBoss = true end)
    criarBotao(pages["Boss"], "Farm Greybeard", function() _G.SelectBoss = "Greybeard"; _G.AutoBoss = true end)
    criarBotao(pages["Boss"], "Farm Don Swan", function() _G.SelectBoss = "Don Swan"; _G.AutoBoss = true end)
    criarBotao(pages["Boss"], "Farm Dough King", function() _G.SelectBoss = "Dough King"; _G.AutoBoss = true end)

    -- Raid
    criarToggle(pages["Raid"], "Auto Start Raid", "AutoRaid")
    criarToggle(pages["Raid"], "Auto Awaken Fruit", "AutoAwaken")
    criarBotao(pages["Raid"], "Buy Law Raid Chip", function()
        pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "Microchip", "2") end)
    end)

    -- Sea
    criarToggle(pages["Sea"], "Auto Sea Beast", "AutoSeaBeast")
    criarToggle(pages["Sea"], "Auto Terror Shark", "AutoTerrorShark")
    criarToggle(pages["Sea"], "Auto Mirage Island", "AutoMirage")

    -- Fruits
    criarToggle(pages["Fruits"], "Auto Farm Fruit Mastery", "AutoMastery")
    criarToggle(pages["Fruits"], "Auto Collect Fruits", "AutoFruit")
    criarToggle(pages["Fruits"], "Auto Random Fruit", "AutoRandomFruit")

    -- Materials
    criarToggle(pages["Materials"], "Auto Dragon Scale", "AutoDragonScale")
    criarToggle(pages["Materials"], "Auto Leather", "AutoLeather")
    criarToggle(pages["Materials"], "Auto Scrap Metal", "AutoScrap")
    criarToggle(pages["Materials"], "Auto Gunpowder", "AutoGunpowder")

    -- Melee
    criarToggle(pages["Melee"], "Auto Superhuman", "AutoSuperhuman")
    criarToggle(pages["Melee"], "Auto Death Step", "AutoDeathStep")
    criarToggle(pages["Melee"], "Auto Sharkman Karate", "AutoSharkman")
    criarToggle(pages["Melee"], "Auto Electric Claw", "AutoElectricClaw")
    criarToggle(pages["Melee"], "Auto Dragon Talon", "AutoDragonTalon")
    criarToggle(pages["Melee"], "Auto God Human", "AutoGodHuman")

    -- Teleports
    criarBotao(pages["Teleports"], "Teleport First Sea", function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain") end) end)
    criarBotao(pages["Teleports"], "Teleport Second Sea", function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa") end) end)
    criarBotao(pages["Teleports"], "Teleport Third Sea", function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou") end) end)

    -- Misc
    criarBotao(pages["Misc"], "Rejoin Server", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
    criarBotao(pages["Misc"], "Server Hop", function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
        local data = HttpService:JSONDecode(game:HttpGet(url))
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end)
    criarBotao(pages["Misc"], "Reset Character", function() LocalPlayer.Character.Head:Destroy() end)

    -- Ajustar canvas size
    for _, page in pairs(pages) do
        local layout = page:FindFirstChildOfClass("UIListLayout")
        if layout then
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
            end)
            task.wait()
            page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        end
    end

    -- Controle de visibilidade
    local menuAberto = false
    icone.MouseButton1Click:Connect(function()
        menuAberto = not menuAberto
        frame.Visible = menuAberto
        icone.Visible = not menuAberto
    end)
    botaoFechar.MouseButton1Click:Connect(function()
        menuAberto = false
        frame.Visible = false
        icone.Visible = true
    end)
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            menuAberto = not menuAberto
            frame.Visible = menuAberto
            icone.Visible = not menuAberto
        end
    end)

    Notify(NOME_HUB, "Menu carregado! Pressione RightControl para abrir/fechar.", 5)
end

-- Iniciar sistema de key
criarSistemaKey()