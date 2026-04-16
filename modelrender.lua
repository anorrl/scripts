game:GetService("ContentProvider"):SetBaseUrl("http://{domain}/")
game:GetService("ScriptContext").ScriptsDisabled = true
game:GetService("Lighting").Outlines = false
local placeid = {placeId}
local accesskey = "{accesskey}"

game:GetObjects("http://{domain}/asset/?id=" .. placeid .. "&access=" .. accesskey .. "&time="..tostring(math.random()))[1].Parent = workspace

return (game:GetService("ThumbnailGenerator"):Click("PNG", 420, 420, true, true))