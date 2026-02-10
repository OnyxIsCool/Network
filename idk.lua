--[[ 
    what the fuck is this
    looks like junkie development
]]

local KeySystem = {}

--// SERVICES
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

--// ASSETS (LUCIDE STYLE ICONS)
-- These are verified working Asset IDs for clean vector icons
local Icons = {
    Key     = "rbxassetid://11443653127", -- Key
    Link    = "rbxassetid://11443655132", -- Link/Globe
    Check   = "rbxassetid://11443658933", -- Check
    Close   = "rbxassetid://11443652875", -- X
    Shield  = "rbxassetid://11443654452", -- Shield
    Copy    = "rbxassetid://11443651167", -- Copy
    Loading = "rbxassetid://11443655610"  -- Spinner
}

--// UTILITY FUNCTIONS
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

--// MAIN FUNCTION
function KeySystem.Start(Config)
    Config = Config or {}
    local Settings = {
        Key = Config.Key or "1234",
        Link = Config.Link or "https://discord.gg/example",
        Title = Config.Title or "CLAIRE SYSTEM",
        Description = Config.Description or "Authentication Required",
        FileName = Config.FileName or "ClaireKey.txt" -- For saving key
    }

    -- 1. Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ClaireLucideSystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Secure Parent
    if gethui then ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui); ScreenGui.Parent = CoreGui
    else ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. Main Container (Glass/Dark Theme)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 1.5, 0) -- Start off-screen (bottom)
    MainFrame.Size = UDim2.new(0, 360, 0, 210)
    
    -- Rounded Corners
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
    
    -- Stroke (Border)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Color = Color3.fromRGB(45, 45, 55)
    UIStroke.Thickness = 1.2
    
    -- Drop Shadow (Glow)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Parent = MainFrame
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -50, 0, -50)
    Shadow.Size = UDim2.new(1, 100, 1, 100)
    Shadow.ZIndex = -1

    -- 3. Header
    local Header = Instance.new("Frame")
    Header.Parent = MainFrame
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 50)
    
    local Title = Instance.new("TextLabel")
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 45, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = Settings.Title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Parent = Header
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Position = UDim2.new(0, 15, 0.5, -10)
    TitleIcon.Size = UDim2.new(0, 20, 0, 20)
    TitleIcon.Image = Icons.Shield
    TitleIcon.ImageColor3 = Color3.fromRGB(114, 137, 218) -- Accent Blue

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Parent = Header
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -35, 0.5, -10)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Image = Icons.Close
    CloseBtn.ImageColor3 = Color3.fromRGB(150, 150, 160)

    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Parent = MainFrame
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 15, 0, 45)
    Subtitle.Size = UDim2.new(1, -30, 0, 20)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = Settings.Description
    Subtitle.TextColor3 = Color3.fromRGB(100, 100, 110)
    Subtitle.TextSize = 12
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left

    -- 4. Input Box
    local InputBg = Instance.new("Frame")
    InputBg.Parent = MainFrame
    InputBg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    InputBg.Position = UDim2.new(0, 15, 0, 75)
    InputBg.Size = UDim2.new(1, -30, 0, 45)
    Instance.new("UICorner", InputBg).CornerRadius = UDim.new(0, 8)
    
    local InputStroke = Instance.new("UIStroke")
    InputStroke.Parent = InputBg
    InputStroke.Color = Color3.fromRGB(50, 50, 60)
    InputStroke.Thickness = 1

    local InputIcon = Instance.new("ImageLabel")
    InputIcon.Parent = InputBg
    InputIcon.BackgroundTransparency = 1
    InputIcon.Position = UDim2.new(0, 12, 0.5, -9)
    InputIcon.Size = UDim2.new(0, 18, 0, 18)
    InputIcon.Image = Icons.Key
    InputIcon.ImageColor3 = Color3.fromRGB(120, 120, 130)

    local KeyBox = Instance.new("TextBox")
    KeyBox.Parent = InputBg
    KeyBox.BackgroundTransparency = 1
    KeyBox.Position = UDim2.new(0, 40, 0, 0)
    KeyBox.Size = UDim2.new(1, -50, 1, 0)
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.PlaceholderText = "Paste Key Here..."
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.fromRGB(240, 240, 240)
    KeyBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 100)
    KeyBox.TextSize = 14
    KeyBox.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Auto-Load Saved Key
    if isfile and isfile(Settings.FileName) then
        KeyBox.Text = readfile(Settings.FileName)
    end

    -- 5. Buttons Container
    local BtnContainer = Instance.new("Frame")
    BtnContainer.Parent = MainFrame
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.Position = UDim2.new(0, 15, 1, -60)
    BtnContainer.Size = UDim2.new(1, -30, 0, 40)

    -- Verify Button
    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Parent = BtnContainer
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Size = UDim2.new(0.65, -5, 1, 0)
    VerifyBtn.Text = "" -- Important: Clear text to add custom label
    VerifyBtn.AutoButtonColor = false
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)
    
    local VerifyGradient = Instance.new("UIGradient")
    VerifyGradient.Parent = VerifyBtn
    VerifyGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 120, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 90, 255))
    }

    local VerifyLabel = Instance.new("TextLabel")
    VerifyLabel.Parent = VerifyBtn
    VerifyLabel.BackgroundTransparency = 1
    VerifyLabel.Size = UDim2.new(1, 0, 1, 0)
    VerifyLabel.Font = Enum.Font.GothamBold
    VerifyLabel.Text = "VERIFY"
    VerifyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyLabel.TextSize = 13
    VerifyLabel.ZIndex = 2 -- Ensure on top

    -- Get Key Button
    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Parent = BtnContainer
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    GetKeyBtn.Position = UDim2.new(0.65, 5, 0, 0)
    GetKeyBtn.Size = UDim2.new(0.35, -5, 1, 0)
    GetKeyBtn.Text = ""
    GetKeyBtn.AutoButtonColor = false
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

    local GetKeyLabel = Instance.new("TextLabel")
    GetKeyLabel.Parent = GetKeyBtn
    GetKeyLabel.BackgroundTransparency = 1
    GetKeyLabel.Size = UDim2.new(1, 0, 1, 0)
    GetKeyLabel.Font = Enum.Font.GothamBold
    GetKeyLabel.Text = "GET KEY"
    GetKeyLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    GetKeyLabel.TextSize = 12
    GetKeyLabel.ZIndex = 2

    --// ANIMATIONS & LOGIC
    MakeDraggable(MainFrame, Header)

    -- Intro Animation (Slide Up)
    MainFrame.Position = UDim2.new(0.5, 0, 1.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()

    -- Button Hover Logic
    local function AddHover(btn)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)
    end
    AddHover(VerifyBtn)
    AddHover(GetKeyBtn)

    -- Close Logic
    local function CloseUI()
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 1.5, 0)}):Play()
        task.wait(0.5)
        ScreenGui:Destroy()
    end
    CloseBtn.MouseButton1Click:Connect(CloseUI)

    -- Get Key Logic
    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(Settings.Link)
            GetKeyLabel.Text = "COPIED"
            GetKeyLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            task.wait(1.5)
            GetKeyLabel.Text = "GET KEY"
            GetKeyLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
        else
            GetKeyLabel.Text = "NO CLIPBOARD"
        end
    end)

    -- Verify Logic
    VerifyBtn.MouseButton1Click:Connect(function()
        VerifyLabel.Text = "CHECKING..."
        
        -- Simple check logic (replace with your validation)
        task.wait(1) 
        
        if KeyBox.Text == Settings.Key then
            -- Success
            VerifyLabel.Text = "SUCCESS"
            VerifyGradient.Color = ColorSequence.new(Color3.fromRGB(80, 200, 120)) -- Green
            InputStroke.Color = Color3.fromRGB(80, 200, 120)
            
            -- Save Key
            if writefile then
                writefile(Settings.FileName, KeyBox.Text)
            end

            task.wait(1)
            CloseUI()
            
            -- SIGNAL SUCCESS
            if Config.Callback then Config.Callback() end
        else
            -- Fail
            VerifyLabel.Text = "INVALID KEY"
            VerifyGradient.Color = ColorSequence.new(Color3.fromRGB(255, 80, 80)) -- Red
            InputStroke.Color = Color3.fromRGB(255, 80, 80)
            
            -- Shake Animation
            local x = MainFrame.Position.X.Scale
            local y = MainFrame.Position.Y.Scale
            for i = 1, 6 do
                MainFrame.Position = UDim2.new(x, math.random(-5,5), y, 0)
                task.wait(0.03)
            end
            MainFrame.Position = UDim2.new(x, 0, y, 0)
            
            task.wait(1)
            VerifyLabel.Text = "VERIFY"
            VerifyGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 120, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 90, 255))}
            InputStroke.Color = Color3.fromRGB(50, 50, 60)
        end
    end)
end

return KeySystem
