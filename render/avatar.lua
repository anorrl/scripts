local isHeadshot = {isHeadshot}
local isClothing = {isClothing}
local userId = {requestId}
local is3D = {is3D}

game:GetService("ContentProvider"):SetBaseUrl("http://{domain}/")
game:GetService("ScriptContext").ScriptsDisabled = true
game:GetService("Lighting").Outlines = false

game:SetPlaceId(19) -- grace fuck you fix the gears

local player = game:GetService("Players"):CreateLocalPlayer(0)

local getterURL = "userId"
if isClothing then
	getterURL = "assetId"
end

player.CharacterAppearance = "http://{domain}/Asset/CharacterFetch.ashx?" .. getterURL .. "={requestId}"

player:LoadCharacter(false)

if not isHeadshot then
	if player.Character and not isClothing then
		local backpack = player.Backpack:GetChildren()
		local chosen = nil

		while not chosen and #backpack > 0 do
			local defrandom = math.random(1, #backpack)
			local item = backpack[defrandom]

			if math.random() <= 0.5 then
				chosen = item
			else
				wait(0.05)
			end
		end

		if chosen then
			chosen.Parent = player.Character

			if chosen:IsA("Tool") then
				player.Character.Torso["Right Shoulder"].CurrentAngle = math.rad(90)
			end
		end
	end
else
	local CameraAngle = player.Character.Head.CFrame * CFrame.new(0, 0, 0)
	local CameraPosition = player.Character.Head.CFrame + Vector3.new(0, 0, 0) + (CFrame.Angles(0, -0.2, 0).lookVector.unit * 3)
	local Camera = Instance.new("Camera", player.Character)
	
	Camera.Name = "ThumbnailCamera"
	Camera.CameraType = Enum.CameraType.Scriptable
	Camera.CoordinateFrame = CFrame.new(CameraPosition.p, CameraAngle.p)
	Camera.FieldOfView = 52.5
	
	workspace.CurrentCamera = Camera
end

if is3D then
	return game:GetService("ThumbnailGenerator"):Click("OBJ", 420, 420, true)
else
	return (game:GetService("ThumbnailGenerator"):Click("PNG", 420, 420, true))
end