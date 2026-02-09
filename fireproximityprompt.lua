local _env = getgenv()
local badExecutors = {"Xeno", "Solara"}
local execName, exeVersion = (_env.identifyexecutor or function() return "Solara", "version?" end)()
local placeId = game.PlaceId

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

if _env.fireproximityprompt and table.find(badExecutors, execName) and not _env.isFireproximityPrompt then
    warn("[sUNC] Your ".. execName .." exploit has fireproximityprompt support")
    _env.isFireproximityPrompt = true

    shared.supportSunc = {}
    shared.supportSunc.fireProximityPromptFuncs = {}
    
    _env.fireproximityprompt = function(prompt, cameraStand)
        local camera = workspace.CurrentCamera
        local oldHoldDuration = prompt.HoldDuration
        local oldLineOfSight = prompt.RequiresLineOfSight
        local oldMaxDistance = prompt.MaxActivationDistance
        local oldCameraCFrame = camera.CFrame
        local oldCameraType = camera.CameraType
        local funcs = shared.supportSunc.fireProximityPromptFuncs

        local function getCameraStand(prompt)
            if cameraStand then return cameraStand end

            local promptModel = prompt and prompt:FindFirstAncestorWhichIsA("Model")
            local promptBasePart = prompt and prompt:FindFirstAncestorWhichIsA("BasePart")
            local isHumanoidRootPart = promptModel and promptModel:FindFirstChild("HumanoidRootPart", true)

            if promptBasePart then return promptBasePart end
            if isHumanoidRootPart and isHumanoidRootPart:IsA("BasePart") then return isHumanoidRootPart end

            if promptModel then
                for _, part in ipairs(promptModel:getDescendants()) do
                    if part and part:IsA("BasePart") then return part end
                end
            end

            warn("[sUNC System] there is no support for camera (fireproximityprompt)")
            return
        end

        local success, err = pcall(function()
            if funcs and funcs.Activated then funcs.Activated() end    
            task.wait(0.3)
        
            local targetPart = getCameraStand(prompt)
            local centerPosition = targetPart and targetPart.Position
            if not centerPosition then return end

            prompt.Enabled = true
            prompt.HoldDuration = 0
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = math.huge

            task.wait(0.1)

            camera.CameraType = Enum.CameraType.Scriptable

            local offset = Vector3.new(0, 5, oldMaxDistance)
            local cameraPosition = centerPosition + offset

            camera.CFrame = CFrame.new(cameraPosition, centerPosition)

            task.wait(0.1)
            prompt:InputHoldBegin()
            task.wait(0.1)
            prompt:InputHoldEnd()
        end)

        prompt.HoldDuration = oldHoldDuration
        prompt.RequiresLineOfSight = oldLineOfSight
        prompt.MaxActivationDistance = oldMaxDistance
        camera.CFrame = oldCameraCFrame
        camera.CameraType = oldCameraType

        if funcs and funcs.Disabled then funcs.Disabled() end
        
        task.wait(0.3)
        
        if not success then
            warn("[sUNC System] an error occurred while firing proximity prompt", err)
            return false
        end
        return true
    end
end
