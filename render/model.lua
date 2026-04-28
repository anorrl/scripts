game:GetService("ContentProvider"):SetBaseUrl("http://{domain}/")
game:GetService("ScriptContext").ScriptsDisabled = true
game:GetService("Lighting").Outlines = false

local is3D = {is3D}

game:GetObjects("http://{domain}/asset/?id={requestId}&time="..tostring(math.random()))[1].Parent = workspace

if is3D then
	return (game:GetService("ThumbnailGenerator"):Click("OBJ", 420, 420, true, true))
else
	return (game:GetService("ThumbnailGenerator"):Click("PNG", 420, 420, true, true))
end