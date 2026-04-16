game:GetService("ContentProvider"):SetBaseUrl("http://{domain}/")
game:GetService("ScriptContext").ScriptsDisabled = true
game:GetService("Lighting").Outlines = false

local part = Instance.new("Part", workspace)
part.Size = Vector3.new(4,4,4)

local placeid = {placeId}
local accesskey = "{accesskey}"

Instance.new("SpecialMesh", part).MeshId = "http://{domain}/asset/?id=" .. placeid .. "&access=" .. accesskey
				
return (game:GetService("ThumbnailGenerator"):Click("PNG", 420, 420, true))