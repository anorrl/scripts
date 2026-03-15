game:GetService("ContentProvider"):SetBaseUrl("http://arl.lambda.cam/")
game:GetService("ScriptContext").ScriptsDisabled = true
game:GetService("Lighting").Outlines = false
local placeid = {placeId}
local accesskey = "{accesskey}"

game:GetObjects("http://arl.lambda.cam/asset?id=" .. placeid .. "&access=" .. accesskey .. "&time="..tostring(math.random()))[1].Parent = workspace

return (game:GetService("ThumbnailGenerator"):Click("PNG", 420, 420, true, true))