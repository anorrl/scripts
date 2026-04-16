local isheadshot = {isheadshot}
local isclothing = {isclothing}
local userId = {placeId}
game:GetService("ContentProvider"):SetBaseUrl("http://arl.lambda.cam/")
game:GetService("ScriptContext").ScriptsDisabled = true
game:GetService("Lighting").Outlines = false

game:SetPlaceId(19) -- grace fuck you fix the gears

local player = game:GetService("Players"):CreateLocalPlayer(0)
if (isclothing == true) then
	player.CharacterAppearance = "http://arl.lambda.cam/Asset/CharacterFetch.ashx?assetId=" .. userId .. "&access={accesskey}"
else
	player.CharacterAppearance = "http://arl.lambda.cam/Asset/CharacterFetch.ashx?userId=" .. userId
end
player:LoadCharacter(false)

if (isheadshot == false) then
	if (player.Character and isclothing == false) then
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

return (game:GetService("ThumbnailGenerator"):Click("PNG", 420, 420, true))