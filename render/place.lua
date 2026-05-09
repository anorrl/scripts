-- Place v1.0.3
-- added humanoid display remover and startergui remover (probably handled in the showdevgui boolean but oh well)

local assetUrl, fileExtension, x, y, baseUrl, placeId, universeId = "/asset/?id=", "PNG", 768, 432, "http://{domain}", {requestId}, {universeId}

local ThumbnailGenerator = game:GetService("ThumbnailGenerator")

pcall(function() game:GetService("ContentProvider"):SetBaseUrl(baseUrl) end)
if placeId ~= nil then
	pcall(function() game:SetPlaceId(placeId) end)
end

if universeId ~= nil then
	pcall(function() game:SetUniverseId(universeId) end)
end

game:GetService("ScriptContext").ScriptsDisabled = true
game:GetService("StarterGui").ShowDevelopmentGui = false

game:Load(baseUrl .. assetUrl .. placeId)

-- Do this after again loading the place file to ensure that these values aren't changed when the place file is loaded.
game:GetService("ScriptContext").ScriptsDisabled = true
game:GetService("StarterGui").ShowDevelopmentGui = false

for _, v in pairs(workspace:GetDescendants()) do
	if v:IsA("Message") or v:IsA("Hint") then
		v:Remove()
	elseif v:IsA("Humanoid") then
		v.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end
end

return ThumbnailGenerator:Click(fileExtension, x, y, --[[hideSky = ]] false)
