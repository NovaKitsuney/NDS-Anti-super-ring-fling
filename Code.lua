--[[
    ================================================================
    [ OYB OFFICIAL | ROBLOX DEVELOPER ]
    Website: https://oybofficial.com/
    Builder: https://oybofficial.com/keysystem
    YouTube: https://youtube.com/@OYBOfficial
    Discord: https://discord.gg/kT55J724BK
    ================================================================
]]

-- ⚠️ IMPORTANT: Put this code at the VERY TOP of your Main Script (before obfuscating) ⚠️

local ProtectionConfig = {
    -- 🔴 CRITICAL: This MUST exactly match the 'Secret' value in your Key System's Config!
    -- If your Key System has: Secret = "Test"
    -- Then this must also be: SecretKey = "Test"
    SecretKey = "NDS antifling",
    
    -- The name of your Hub (shown in the kick message if they try to bypass)
    HubName = "NDS Anti super ring fling"
}

-- Anti-Bypass Logic: Checks if the Key System successfully set the global variable
if not _G[ProtectionConfig.SecretKey] then
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("\n🛡️ Unauthorized Execution 🛡️\n\nPlease use the official Key System to run " .. ProtectionConfig.HubName)
    end
    return -- Stops the rest of the script from loading!
end

-------------------------------------------------------------------------------
-- 👇 YOUR MAIN SCRIPT CODE STARTS HERE 👇
-------------------------------------------------------------------------------

print(ProtectionConfig.HubName .. " Loaded Successfully!")



local lp = game.Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")

-- 1. Automatic Cleanup
if workspace:FindFirstChild("XenoFixedSafetyShield") then 
    workspace.XenoFixedSafetyShield:Destroy() 
end

-- ==================== AUTOMATIC ISLAND SNAP MATRIX ====================
local islandX, islandY, islandZ = 0, 45.0, 0 -- Updated default elevation fallbacks
local islandRadius = 145 

-- Automatically locate the Natural Disaster Survival island model base
local islandMesh = workspace:FindFirstChild("Island") or workspace:FindFirstChild("Map")
if islandMesh and islandMesh:IsA("BasePart") then
    islandX = islandMesh.Position.X
    -- HEIGHT CORRECTION: Boosted up to + 2.3 studs to cleanly sit right on top of the grass floor line
    islandY = islandMesh.Position.Y + 2.3 
    islandZ = islandMesh.Position.Z
    islandRadius = math.max(islandMesh.Size.X, islandMesh.Size.Z) / 2
end

-- 2. Create the Fixed Safety Shield Part
local TargetPart = Instance.new("Part")
TargetPart.Name = "XenoFixedSafetyShield"

-- Cylinder setup mapped flat to act as a solid floor disc
TargetPart.Shape = Enum.PartType.Cylinder
TargetPart.Size = Vector3.new(0.4, islandRadius * 2, islandRadius * 2) 

-- Rotate exactly 90 degrees on the Z-axis to keep it completely flat
TargetPart.CFrame = CFrame.new(islandX, islandY, islandZ) * CFrame.Angles(0, 0, math.rad(90))

TargetPart.Material = Enum.Material.SmoothPlastic -- Frictionless mesh prevents terrain glitching
TargetPart.Color = Color3.fromRGB(0, 120, 255)
TargetPart.Transparency = 1 -- Translucent blue layout layout
TargetPart.Anchored = true
TargetPart.CanCollide = true -- Keeps incoming rings from sliding under the map geometry
TargetPart.Parent = workspace

-- ==================== FRICTIONLESS CHARACTER PASS-THROUGH ====================
game:GetService("RunService").PreSimulation:Connect(function()
    if TargetPart and TargetPart.Parent and lp.Character then
        local rootPart = lp.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local dist = (Vector3.new(rootPart.Position.X, islandY, rootPart.Position.Z) - TargetPart.Position).Magnitude
            if dist <= islandRadius + 15 then
                for _, limb in ipairs(lp.Character:GetDescendants()) do
                    if limb:IsA("BasePart") then limb.CanCollide = false end
                end
            end
        end
    end
end)
