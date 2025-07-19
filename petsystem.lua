-- Grow A Garden: Master Pet System Script (Raccoon Pet Full Integration)
-- Fitur: Spawner, Visible, Placeable, Tradable, GUI-ready

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Konfigurasi
local PetName = "Raccoon"
local PetWeight = 8.67
local PetAge = 8

-- Ambil Template dari ReplicatedStorage
local function getPetTemplate()
    local petModels = ReplicatedStorage:FindFirstChild("PetModels")
    if not petModels then warn("PetModels folder tidak ditemukan di ReplicatedStorage") return nil end
    local pet = petModels:FindFirstChild(PetName)
    if not pet then warn("Pet Raccoon tidak ditemukan di PetModels") end
    return pet
end

-- Fungsi untuk spawn pet
local function spawnPet(player)
    local PetTemplate = getPetTemplate()
    if not PetTemplate then return end

    local pet = PetTemplate:Clone()
    pet.Name = PetName .. "_" .. player.Name
    pet:SetAttribute("Age", PetAge)
    pet:SetAttribute("Weight", PetWeight)
    pet:SetAttribute("Owner", player.UserId)
    pet:SetAttribute("CanTrade", true)
    pet:SetAttribute("CanPlace", true)

    pet.PrimaryPart = pet:FindFirstChild("HumanoidRootPart") or pet:FindFirstChildWhichIsA("BasePart")
    if not pet.PrimaryPart then return end

    local character = player.Character or player.CharacterAdded:Wait()
    pet:SetPrimaryPartCFrame(character:WaitForChild("HumanoidRootPart").CFrame * CFrame.new(3, 0, 3))
    pet.Parent = workspace
end

-- Fungsi GUI Spawner (untuk dimasukkan ke Hub)
local function createPetButton()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PetSpawnerGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 160, 0, 40)
    button.Position = UDim2.new(0, 20, 0, 60)
    button.Text = "Spawn Raccoon Pet"
    button.Parent = ScreenGui

    button.MouseButton1Click:Connect(function()
        spawnPet(Players.LocalPlayer)
    end)
end

-- Hubungkan GUI jika LocalScript
if pcall(function() return Players.LocalPlayer end) then
    createPetButton()
end

-- Spawn otomatis jika ServerScript
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(2)
        spawnPet(player)
    end)
end)
