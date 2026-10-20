-- ===== Vampauth key check (keep at top) =====
local KEY = getgenv().script_key or ""
if KEY == "" then
    return warn("[NDS Anti super ring fling] No key. Set getgenv().script_key = \"YOUR-KEY\" then run again.")
end

local Vampauth = loadstring(game:HttpGet("https://vampauth.com/client/vampauth.lua"))()
local vp = Vampauth.new({
    projectId  = "BK2CSP8WO6J3N97I",   -- from project page
    authSecret = "6cc3f9b718eb302a85567913e9dd74331222ed0859daa4bf", -- from project page (keep private)
})

local ok, data = vp:Check(KEY)
if not ok then
    return warn("[NDS Anti super ring fling] Invalid / expired key:", data)
end
-- ===== end key check — your script starts below =====

-- your full script here (NDS Anti super ring fling / whatever)



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
