loadstring([[
-- 🔁 Buat RemoteEvent jika belum ada
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local spawnEvent = ReplicatedStorage:FindFirstChild("SpawnPet") or Instance.new("RemoteEvent", ReplicatedStorage)
spawnEvent.Name = "SpawnPet"
local tradeEvent = ReplicatedStorage:FindFirstChild("TradePet") or Instance.new("RemoteEvent", ReplicatedStorage)
tradeEvent.Name = "TradePet"

local petFolder = workspace:FindFirstChild("SpawnedPets") or Instance.new("Folder", workspace)
petFolder.Name = "SpawnedPets"

-- 🔧 Buat Pet
local function createPet()
	local pet = Instance.new("Part")
	pet.Name = "Pet"
	pet.Shape = Enum.PartType.Ball
	pet.Size = Vector3.new(2, 2, 2)
	pet.Color = Color3.fromRGB(139, 69, 19)
	pet.Anchored = false
	pet.CanCollide = false
	pet:SetAttribute("Age", 8)
	pet:SetAttribute("Weight", 8.67)

	local billboard = Instance.new("BillboardGui", pet)
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextScaled = true
	label.Text = "Age: 8 | Weight: 8.67kg"
	label.TextColor3 = Color3.new(1, 1, 1)

	return pet
end

-- 🐾 Spawn Pet
spawnEvent.OnServerEvent:Connect(function(player)
	local existingPet = petFolder:FindFirstChild(player.Name .. "'s Pet")
	if existingPet then existingPet:Destroy() end
	local pet = createPet()
	pet.Name = player.Name .. "'s Pet"
	pet.Position = player.Character.HumanoidRootPart.Position + Vector3.new(3, 0, 0)
	pet.Parent = petFolder
	local weld = Instance.new("WeldConstraint", pet)
	weld.Part0 = pet
	weld.Part1 = player.Character.HumanoidRootPart
end)

-- 🔁 Trade Pet
tradeEvent.OnServerEvent:Connect(function(sender, targetName)
	local target = Players:FindFirstChild(targetName)
	if not target then return end
	local pet = petFolder:FindFirstChild(sender.Name .. "'s Pet")
	if not pet then return end
	local newPet = pet:Clone()
	newPet.Name = target.Name .. "'s Pet"
	newPet.Position = target.Character.HumanoidRootPart.Position + Vector3.new(3,0,0)
	newPet.Parent = petFolder
	local weld = Instance.new("WeldConstraint", newPet)
	weld.Part0 = newPet
	weld.Part1 = target.Character.HumanoidRootPart
	pet:Destroy()
end)

-- 🌐 GUI Client Menu (Auto GUI inject)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PetHubGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 160)
frame.Position = UDim2.new(0.5, -125, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local spawnButton = Instance.new("TextButton", frame)
spawnButton.Size = UDim2.new(0, 200, 0, 30)
spawnButton.Position = UDim2.new(0, 25, 0, 10)
spawnButton.Text = "🐾 Spawn Pet"

local targetBox = Instance.new("TextBox", frame)
targetBox.Size = UDim2.new(0, 200, 0, 30)
targetBox.Position = UDim2.new(0, 25, 0, 50)
targetBox.PlaceholderText = "Nama Player"

local tradeButton = Instance.new("TextButton", frame)
tradeButton.Size = UDim2.new(0, 200, 0, 30)
tradeButton.Position = UDim2.new(0, 25, 0, 90)
tradeButton.Text = "🔁 Trade Pet"

local infoButton = Instance.new("TextButton", frame)
infoButton.Size = UDim2.new(0, 200, 0, 30)
infoButton.Position = UDim2.new(0, 25, 0, 130)
infoButton.Text = "📦 Lihat Data Pet"

local rs = game:GetService("ReplicatedStorage")
spawnButton.MouseButton1Click:Connect(function()
	rs:WaitForChild("SpawnPet"):FireServer()
end)
tradeButton.MouseButton1Click:Connect(function()
	local name = targetBox.Text
	if name ~= "" then
		rs:WaitForChild("TradePet"):FireServer(name)
	end
end)
infoButton.MouseButton1Click:Connect(function()
	local pet = workspace:FindFirstChild("SpawnedPets"):FindFirstChild(player.Name .. "'s Pet")
	if pet then
		local a = pet:GetAttribute("Age")
		local w = pet:GetAttribute("Weight")
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "🐾 Pet Kamu | Age: " .. a .. " | Weight: " .. w .. "kg",
			Color = Color3.fromRGB(255, 255, 255)
		})
	end
end)
]])()