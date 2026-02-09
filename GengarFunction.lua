local _env = getgenv()
local GGFunctions = {}
local mainDir: string = "https://raw.githubusercontent.com/OnyxIsCool/Network/refs/heads/main/"
local flyModule = loadstring(game:HttpGet(mainDir .. "flyModule.lua"))()
local fireproximityprompt = loadstring(game:HttpGet(mainDir .. "fireproximityprompt.lua"))()

local VirtualInputManager: VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser: VirtualUser = game:GetService("VirtualUser")
local TextChatService: TextChatService = game:GetService("TextChatService")
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local Light: Lighting = game:GetService("Lighting")

local Camera: Camera = workspace.CurrentCamera
local Chat: TextChannel = TextChatService.ChatInputBarConfiguration.TargetTextChannel
local LocalPlayer: Player = Players.LocalPlayer
local Character: Model = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart: BasePart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

shared.configLight = shared.configLight or {
  ["Ambient"] = Light.Ambient,
  ["ColorShift_Bottom"] = Light.ColorShift_Bottom,
  ["ColorShift_Top"] = Light.ColorShift_Top
}

shared.connections = shared.connections or {}

for nameConn, valueConc: RBXScriptConnection in pairs(shared.connections) do
    shared.connections[nameConn]:Disconnect()
    shared.connections[nameConn] = nil
end

shared.Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local monitorCharacter = shared.connections["monitorCharacter"]

if monitorCharacter then monitorCharacter:Disconnect(); shared.connections["monitorCharacter"] = nil end
monitorCharacter = RunService.Heartbeat:Connect(function()
  local newcharacter: Model = LocalPlayer.Character
  HumanoidRootPart = newcharacter and newcharacter:FindFirstChild("HumanoidRootPart")
  
  Character = newcharacter
  shared.Character = newcharacter
end)

local links: { string } = {
  "https://raw.githubusercontent.com/OnyxIsCool/Luanet/refs/heads/main/commands.lua"
}

for index: number, link: string in pairs(links) do
  task.spawn(function()
      local result: boolean, content: any = pcall(function() loadstring(game:HttpGet(link))() end)
      warn("[GG System] Checking the results... " .. index, result) 
  end)
end

function GGFunctions.CreateESPObject(object: Instance, color: Color3, imageId: string, text: string)
  if object:FindFirstChild("GGHubIconSystem") or object:FindFirstChild("GGHubHighlightSystem") then 
    return
  end

  local objectPart: BasePart | MeshPart;
  local objects: { Instance } = object:GetDescendants()

  for _, part: BasePart | MeshPart in ipairs(objects) do
    if part.Name == "HumanoidRootPart" and (part:IsA("BasePart") or part:IsA("MeshPart")) then
      objectPart = part
      break
    end
  end
    
  if not objectPart then
    for _, part: BasePart | MeshPart in ipairs(objects) do
      if part:IsA("BasePart") or part:IsA("MeshPart") then
        objectPart = part
        break
      end
    end
  end

  local GGHubHighlightSystem: Highlight = Instance.new("Highlight")
  GGHubHighlightSystem.Name = "GGHubHighlightSystem"
  GGHubHighlightSystem.Adornee = object
  GGHubHighlightSystem.FillColor = color or Color3.fromRGB(255, 255, 255)
  GGHubHighlightSystem.Parent = object

  local isNotPart: boolean = (not objectPart and (object:IsA("BasePart") or object:IsA("MeshPart")))
  if isNotPart then objectPart = object end
  if not objectPart then return end

  local billboard: BillboardGui = Instance.new("BillboardGui")
  billboard.Name = "GGHubIconSystem"
  billboard.Adornee = objectPart
  billboard.Size = UDim2.new(0, 30, 0, 30)
  billboard.StudsOffset = Vector3.new(0, 0, 0)
  billboard.AlwaysOnTop = true
  billboard.Parent = object

  local imageLabel: ImageLabel = Instance.new("ImageLabel")
  imageLabel.Size = UDim2.new(1, 0, 1, 0)
  imageLabel.BackgroundTransparency = 1
  imageLabel.Image = "rbxassetid://" .. imageId or "12905962634"
  imageLabel.Parent = billboard
  
  local textLabel: TextLabel = Instance.new("TextLabel")
  textLabel.Size = UDim2.new(1, 0, 1, 0)
  textLabel.BackgroundTransparency = 1
  textLabel.Text = text or "Instance"
  textLabel.Position = UDim2.new(0, 0, 0, 20)
  textLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
  textLabel.TextSize = 13
  textLabel.Font = Enum.Font.GothamBold
  textLabel.Parent = billboard
end

function GGFunctions.CreateESPDistance(object: Instance, color: Color3, text: string, showDistance: boolean)
  if object:FindFirstChild("GGHubIconSystem") or object:FindFirstChild("GGHubHighlightSystem") then 
    return 
  end

  local objectPart: BasePart | MeshPart;
  local objects: { Instance } = object:GetDescendants()

  for _, part: BasePart | MeshPart in ipairs(objects) do
    if part.Name == "HumanoidRootPart" and (part:IsA("BasePart") or part:IsA("MeshPart")) then
      objectPart = part
      break
    end
  end
  
  if not objectPart then
    for _, part: BasePart | MeshPart in ipairs(objects) do
      if part:IsA("BasePart") or part:IsA("MeshPart") then
        objectPart = part
        break
      end
    end
  end

  local GGHubHighlightSystem: Highlight = Instance.new("Highlight")
  GGHubHighlightSystem.Name = "GGHubHighlightSystem"
  GGHubHighlightSystem.Adornee = object
  GGHubHighlightSystem.FillColor = color or Color3.fromRGB(255, 255, 255)
  GGHubHighlightSystem.Parent = object

  local isNotPart: boolean = (not objectPart and (object:IsA("BasePart") or object:IsA("MeshPart")))
  if isNotPart then objectPart = object end
  if not objectPart then return end

  local billboard: BillboardGui = Instance.new("BillboardGui")
  billboard.Name = "GGHubIconSystem"
  billboard.Adornee = objectPart
  billboard.Size = UDim2.new(0, 50, 0, 50)
  billboard.StudsOffset = Vector3.new(0, 0, 0)
  billboard.AlwaysOnTop = true
  billboard.Parent = object
    
  local textLabel: TextLabel = Instance.new("TextLabel")
  textLabel.Size = UDim2.new(1, 0, 1, 0)
  textLabel.BackgroundTransparency = 1
  textLabel.Text = text or "Instance"
  textLabel.Position = UDim2.new(0, 0, 0, 0)
  textLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
  textLabel.TextSize = 13
  textLabel.Font = Enum.Font.GothamBold
  textLabel.Parent = billboard

  local distanceLabel: TextLabel = Instance.new("TextLabel")
  distanceLabel.Size = UDim2.new(1, 0, 1, 0)
  distanceLabel.BackgroundTransparency = 1
  distanceLabel.Text = ""
  distanceLabel.Position = UDim2.new(0, 0, 0, 12)
  distanceLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
  distanceLabel.TextSize = 13
  distanceLabel.Font = Enum.Font.GothamBold
  distanceLabel.Parent = billboard

  if not showDistance then return end

  RunService.RenderStepped:Connect(function()
    local targetRoot: BasePart = Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot and not objectPart then return end

    local playerPos = Character.HumanoidRootPart.Position
    local objectPos = objectPart.Position
    local distance = (playerPos - objectPos).Magnitude
      
    distanceLabel.Text = "Distance: " .. math.floor(distance) .. " studs"
  end)
end

function GGFunctions.ActivePlayerESP()
  for _, player: Player in ipairs(Players:GetPlayers()) do

    local targetCharacter = player.Character
    local GGHubHighlightSystem: Highlight = player:FindFirstChild("raelhubhighlight")
    local GGHubIconSystem: BillboardGui  = player:FindFirstChild("raelhubicon")

    if not targetCharacter or GGHubHighlightSystem or GGHubIconSystem then continue end

    GGFunctions.CreateESP(targetCharacter, Color3.fromRGB(144, 238, 144), "117259180607823", player.Name)
  end
end

function GGFunctions.DisableESP(object: Instance)
  if not object then warn("[GG System] Object Not Found!"); return end

  local GGHubHighlightSystem: Highlight = object:FindFirstChild("GGHubHighlightSystem")
  local GGHubIconSystem: BillboardGui  = object:FindFirstChild("GGHubIconSystem")
  
  if GGHubHighlightSystem then GGHubHighlightSystem:Destroy() end
  if GGHubIconSystem then GGHubIconSystem:Destroy() end
end

function GGFunctions.AutoClick1(value: boolean)
  _env.GGAutoClick1 = value
  
  local function mouseClick()
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(1e4, 1e4))
    task.wait(0.05)
  end
  
  task.spawn(function()
    while _env.GGAutoClick1 do
      task.wait()
      mouseClick()
    end
  end)
end

function GGFunctions.AutoClick2(value: boolean)
  _env.GGAutoClick2 = value
  
  local function mouseClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    task.wait(0.05)
  end
  
  task.spawn(function()
    while _env.GGAutoClick2 do
      task.wait()
      mouseClick()
    end
  end)
end

function GGFunctions.CreateFloor(position: Vector3, bool: boolean, transparency: number, colorRGB: Color3)
  local folderParts: Folder = workspace:FindFirstChild("RaelHubFloor") or Instance.new("Folder")
  folderParts.Name = "GGFloor"
  folderParts.Parent = workspace

  local part: BasePart = Instance.new("Part")
  part.Size = Vector3.new(10, 1, 10)
  part.Position = position
  part.Anchored = true
  part.Color = colorRGB
  part.Transparency = transparency
  part.Parent = folderParts

  local function createPart(position: Vector3, size: number)
    local Part: BasePart = Instance.new("Part")
    Part.Size = size
    Part.Position = position
    Part.Anchored = true
    Part.CanCollide = true
    Part.Transparency = 1
    Part.Color = Color3.fromRGB(0, 0, 255)
    Part.Parent = folderParts
  end

  local PartThickness: number = 1
  local PartHeight: number = 10

  local PartPositions: { Vector3 } = {
    Vector3.new(part.Position.X, part.Position.Y + PartHeight / 2, part.Position.Z - part.Size.Z / 2 - PartThickness / 2),
    Vector3.new(part.Position.X, part.Position.Y + PartHeight / 2, part.Position.Z + part.Size.Z / 2 + PartThickness / 2),
    Vector3.new(part.Position.X - part.Size.X / 2 - PartThickness / 2, part.Position.Y + PartHeight / 2, part.Position.Z),
    Vector3.new(part.Position.X + part.Size.X / 2 + PartThickness / 2, part.Position.Y + PartHeight / 2, part.Position.Z),
  }

  if bool then
    for _, pos in ipairs(PartPositions) do
      if pos.Z == part.Position.Z then
        createPart(pos, Vector3.new(PartThickness, PartHeight, part.Size.Z))
      else
        createPart(pos, Vector3.new(part.Size.X, PartHeight, PartThickness))
      end
    end
  end
end

function GGFunctions.ESPPlayers(value: boolean, method: string)
  _env.GGESPPlayer = value
  
  task.spawn(function()
    while _env.GGESPPlayer do
      
      for _, player: Player in ipairs(Players:GetPlayers()) do
        local targetCharacter: Model = player.Character
        local GGHubHighlightSystem: Highlight = (targetCharacter and targetCharacter:FindFirstChild("GGHubHighlightSystem"))
        local GGHubIconSystem: BillboardGui  = (targetCharacter and targetCharacter:FindFirstChild("GGHubIconSystem"))
        
        if not targetCharacter then continue end

        if method == "Normal" then
          if GGHubHighlightSystem and GGHubIconSystem then continue end        
          GGFunctions.CreateESP(targetCharacter, Color3.fromRGB(144, 238, 144), "117259180607823", player.Name)          
        elseif method == "ShowDistance" then
          if GGHubHighlightSystem and GGHubIconSystem then continue end  
          GGFunctions.CreateESPDistance(targetCharacter, Color3.fromRGB(144, 238, 144), player.Name, true)
        end
      end   
      task.wait(0.1)    
    end 
    if not _env.GGESPPlayer then
      for _, player: Player in ipairs(Players:GetPlayers()) do
        local targetCharacter = player.Character
        if not targetCharacter then continue end
        GGFunctions.DisableESP(targetCharacter)
      end
    end
  end)
end

function GGFunctions.SendInChat(msg: string)
  if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
    ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer(msg, "All")
  else
    Chat:SendAsync(msg)
  end
end

function GGFunctions.FullBright(value: boolean)
    _env.isActiveFullBright = value

    local function activeFullBright()
        Light.Ambient = Color3.new(1, 1, 1)
        Light.ColorShift_Bottom = Color3.new(1, 1, 1)
        Light.ColorShift_Top = Color3.new(1, 1, 1)
    end
    if shared.connections["fullBright"] then
        shared.connections["fullBright"]:Disconnect()
        shared.connections["fullBright"] = nil
    end
    if not _env.isActiveFullBright then
        for configName, configValue in pairs(shared.configLight) do
            Light[configName] = configValue
        end
        return "Done!"
    end
    activeFullBright()
    shared.connections["fullBright"] = Light.LightingChanged:Connect(activeFullBright)
    return "Done!"
end

function GGFunctions.ClickButton(button: TextButton | ImageButton | GuiButton)
    if not _env.getconnections then return warn("[GG System] getconnections does not exist in your executor") end

    local success, err = pcall(function()
        for _, connection: table in pairs(_env.getconnections(button.MouseButton1Click)) do
            if not connection.Function then continue end
            connection.Function()
        end
    end)

    if not success then warn("[GG System] Click Button:", err) end
end

function GGFunctions.FreezePlayer(time: number, sync: boolean)
    local rootPlayer: BasePart = (Character and Character:FindFirstChild("HumanoidRootPart"))
    if not rootPlayer then return warn("[GG System] HumanoidRootPart Does Not Exist!") end

    if not sync then
        task.spawn(function()
            rootPlayer.Anchored = true
            task.wait(time)
            rootPlayer.Anchored = false
        end)
        return "Done!"
    end

    rootPlayer.Anchored = true
    task.wait(time)
    rootPlayer.Anchored = false
    return "Done!"
end

function GGFunctions.FlyToPosition(targetPosition: Vector3, speed: number)
    local rootPlayer: BasePart = (Character and Character:FindFirstChild("HumanoidRootPart"))
    if not rootPlayer then return warn("[GG System] HumanoidRootPart Does Not Exist!") end 

    local bodyVelocity: BodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyToPos"
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.Velocity = (targetPosition - rootPlayer.Position).unit * speed
    bodyVelocity.Parent = rootPlayer

    shared.connections["flyToPosition"] = RunService.Stepped:Connect(function()
        
        if (targetPosition - rootPlayer.Position).magnitude > 5 then return end
        if bodyVelocity then bodyVelocity:Destroy() end

        if shared.connections["flyToPosition"] then
            shared.connections["flyToPosition"]:Disconnect()
            shared.connections["flyToPosition"] = nil
        end
       
        rootPlayer.CFrame = CFrame.new(targetPosition)
    end)
end

function GGFunctions.StopFlyToPosition()
    if not shared.connections["flyToPosition"] then return end
    shared.connections["flyToPosition"]:Disconnect()
    shared.connections["flyToPosition"] = nil
end

function GGFunctions.Noclip(value: boolean)
    _env.GGNoclip = value

    local function noClip(state: boolean)
        if not Character then return end
        for _, part: BasePart | MeshPart in ipairs(Character:GetDescendants()) do
            if (not part:IsA("BasePart") and not part:IsA("MeshPart")) then continue end

            if state then
                if part.CanCollide then
                    part.CanCollide = false
                    part:SetAttribute("GGNoclip", true)
                end
            else
                if part:GetAttribute("GGNoclip") then
                    part.CanCollide = true
                    part:SetAttribute("GGNoclip", nil)
                end
            end
        end
    end

    if not _env.GGNoclip then
        if shared.connections["noClip"] then
          shared.connections["noClip"]:Disconnect()
          shared.connections["noClip"] = nil
        end
        noClip(false)
        return "Noclip Disabled"
    end

    noClip(true)
    shared.connections["noClip"] = RunService.Heartbeat:Connect(function()
      noClip(true)
    end)
    return "Noclip Enabled"
end

function GGFunctions.SpectatePlayer(value: boolean, username: string)
  _env.GGSpectatePlayer = value

  local function spectateplayer(username: string)
    local playerTarget: Player = Players:FindFirstChild(username)
    local characterTarget: Model = (playerTarget and playerTarget.Character)
    local humanoidTarget: Humanoid = (characterTarget and characterTarget:FindFirstChild("Humanoid"))
    
    if not humanoidTarget then warn("[GG System] Player Does Not Exist!"); return end

    Camera.CameraSubject = humanoidTarget
  end
  
  task.spawn(function()
    while _env.GGSpectatePlayer do
      spectateplayer(username)
      task.wait()
    end
    
    if not _env.GGSpectatePlayer then
      local humanoid: Humanoid = Character:FindFirstChild("Humanoid")
      if not humanoid then warn("[GG System] Your Humanoid Does Not Exist!"); return end
      Camera.CameraSubject = humanoid
    end
  end)
end

function GGFunctions.InstantProximityPrompt(value: boolean)
    _env.GGInstantInteraction = value

    local function holdDurationZero()
        for _, prompt: ProximityPrompt in ipairs(workspace:GetDescendants()) do
            if not prompt:IsA("ProximityPrompt") then continue end

            local hold: number = prompt:GetAttribute("GGHold")

            if not hold then
                prompt:SetAttribute("GGHold", prompt.HoldDuration)
            end

            prompt.HoldDuration = 0
        end
    end

     local function holdDurationResert()
        for _, prompt: ProximityPrompt in ipairs(workspace:GetDescendants()) do
            if not prompt:IsA("ProximityPrompt") then continue end

            local hold: number = prompt:GetAttribute("GGOldHold")
            if hold then prompt.HoldDuration = hold end
        end
    end

    if shared.connections["HoldConnection"] then
        shared.connections["HoldConnection"]:Disconnect()
        shared.connections["HoldConnection"] = nil
    end

    if _env.GGInstantInteraction then
        holdDurationZero()

        shared.connections["HoldConnection"] = workspace.DescendantAdded:Connect(function(descendant: ProximityPrompt)
            if descendant and descendant:IsA("ProximityPrompt") then
                local hold: number = descendant:GetAttribute("GGOldHold")

                if not hold then
                    descendant:SetAttribute("GGOldHold", descendant.HoldDuration)
                end

                descendant.HoldDuration = 0
            end
        end)
    else
        holdDurationResert()
    end
end

function GGFunctions.Fly1(value, speed)
  flyModule.flymodel1(value, speed)
end

function GGFunctions.Fly2(value, speed)
  flyModule.flymodel2(value, speed)
end

shared.GGFunctions = GGFunctions

return GGFunctions