game:GetService("ContentProvider"):SetBaseUrl("http://{domain}/")
game:GetService("ScriptContext").ScriptsDisabled = true
game:GetService("Lighting").Outlines = false

local is3D = {is3D}

local size = 4

if is3D then
	size = 1
end

local part = Instance.new("Part", workspace)
part.Size = Vector3.new(size,size,size)

Instance.new("SpecialMesh", part).MeshId = "http://{domain}/asset/?id={requestId}"

if is3D then
	return (game:GetService("ThumbnailGenerator"):Click("OBJ", 420, 420, true))
else
	return (game:GetService("ThumbnailGenerator"):Click("PNG", 420, 420, true))
end