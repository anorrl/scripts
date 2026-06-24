game:GetService("ContentProvider"):SetBaseUrl("http://{domain}/")
game:GetService("ScriptContext").ScriptsDisabled = true
game:GetService("Lighting").Outlines = false

local is3D = {is3D}

game:GetObjects("http://{domain}/asset/?id={requestId}&time="..tostring(math.random()))[1].Parent = workspace

local renderType = "PNG"

if is3D then
	renderType = "OBJ"
end

return (game:GetService("ThumbnailGenerator"):Click(renderType, 420, 420, true, true))
