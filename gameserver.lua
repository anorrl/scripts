-- Start Game Script Arguments
local placeId, port, sleeptime, access, timeout, machineAddress, baseUrl, libraryRegistrationScriptAssetID, universeId, assetGameSubdomain, protocol, jobId, testing =
{placeId}, {port}, 10, "{accesskey}", 10, "37.114.46.52", "lambda.cam", 37801172, {placeId}, "arl", "http://", "{jobId}", false

-----------------------------------"CUSTOM" SHARED CODE----------------------------------
local TeleportService = game:GetService("TeleportService")

pcall(function() settings().Network.UseInstancePacketCache = true end)
pcall(function() settings().Network.UsePhysicsPacketCache = true end)
pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError end)

settings().Network.PhysicsSend = Enum.PhysicsSendMethod.TopNErrors
settings().Network.ExperimentalPhysicsEnabled = true
settings().Network.WaitingForCharacterLogRate = 100
pcall(function() settings().Diagnostics:LegacyScriptMode() end)

local shouldCountDown = true
local countdownTimer = 15

local commands = {";ec", ";cock", ";raymonf", ";gage", ";minecraft", ";suicide", ";energycell", ";cancer", ";bleach", ";sex", ";kms", ";death", ";robloxsuckingpenis", ";korone", ";austiblox", ";pekora", ";liam", ";amir", ";brickplanet", ";polytoriacrashed", ";wm"}
local elivSound = 7569
local ecSounds = {
	1991,
	1993,
	1995,
	1723,
	1725,
	1735
}

function onChatted(msg, speaker)
    local source = string.lower(speaker.Name)
    local msg = string.lower(msg)
	local player = speaker
	
		if msg == "!rejoin" then
		TeleportService:Teleport(placeId, speaker)
		return
	end
	
	if not speaker.Character then return end
	local humanoid = speaker.Character:FindFirstChild("Humanoid")
	if not humanoid then return end
	if msg == "!!!reset" then
		humanoid.Health = 0
		return
	end
	
    for i=1,#commands do
        if msg == commands[i] and speaker.Character.Humanoid.Health > 0 then
            speaker.Character.Humanoid.Health = 0
            local sound = Instance.new("Sound")
            sound.Parent = game.Workspace:FindFirstChild(speaker.Name).Head
            sound.SoundId = protocol .. "arl." .. baseUrl .. "/asset/?id=" .. ecSounds[math.random(1, #ecSounds)]
            wait(0.2)
            sound:Play()
        end
    end
	-- coded by skylerclock
	if msg == ";eliv" and speaker.Character.Humanoid.Health > 0 then
		speaker.Character.Humanoid.Health = 0
		local sound = Instance.new("Sound")
		sound.Parent = speaker.Character.Head
		sound.SoundId = protocol .. "arl." .. baseUrl .. "/asset/?id=" .. elivSound
		wait(0.2)
		sound:Play()
	end
	if game:GetService("Players").ArbysChibkenEnabled then
		if msg == "arbys chibken" then
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://327"
			sound.Volume = 0.5
			sound.Parent = speaker.Character
			sound:Play()
			wait(2)
			local explosion = Instance.new("Explosion")
			explosion.Position = speaker.Character.Torso.Position
			explosion.Parent = speaker.Character.Torso
		end
	end
end

if (placeId == 3724) then
	warn("Testing enabled")
	testing = true
end

local function waitForAccoutrement(character)
    local tries = 0
    while tries < 20 do
        local hasAccoutrement = false
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Accoutrement") then
                hasAccoutrement = true
                break
            end
        end
        if hasAccoutrement then
            break
        end
        wait(0.05)
        tries = tries + 1
    end
end

local function waitForClothing(character)
    local tries = 0
    while tries < 20 do
        local hasClothing = false
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
                hasClothing = true
                break
            end
        end
        if hasClothing then
            break
        end
        wait(0.05)
        tries = tries + 1
    end
end
-----------------------------------START GAME SHARED SCRIPT------------------------------

local assetId = placeId -- might be able to remove this now
local url = nil
local assetGameUrl = nil
local saveUrl = nil
local whitelist = {
	1,
	43,
	62
}
if baseUrl~=nil and protocol ~= nil then
	url = protocol .. "arl." .. baseUrl --baseUrl is actually the domain, no leading .
	assetGameUrl = protocol .. assetGameSubdomain .. "." .. baseUrl
	saveUrl = url .. "/Data/Upload.ashx?assetid=" .. placeId .. "&access=" .. access
end

local scriptContext = game:GetService('ScriptContext')
pcall(function() scriptContext:AddStarterScript(libraryRegistrationScriptAssetID) end)
scriptContext.ScriptsDisabled = true

game:SetPlaceID(assetId, false)
pcall(function () if universeId ~= nil then game:SetUniverseId(universeId) end end)
game:GetService("ChangeHistoryService"):SetEnabled(false)

function GetAsync(url)
	url = HttpRbx .. url
	local response, result = pcall(function()
		game:HttpGet(url)
	end)
	
	wait()
	
	if response then
		return response
	else
		return warn(result)
	end
end

function PostAsync(url, data, contentType)
	contentType = contentType or "application/x-www-form-urlencoded"

	if type(data) == "table" then
		local str = ""
		for k, v in pairs(data) do
			if str ~= "" then
				str = str .. "&"
			end
			str = str .. tostring(k) .. "=" .. tostring(v)
		end
		data = str
	end

	local ok, response = pcall(function()
		return game:GetService("HttpRbxApiService"):PostAsync(url, data, contentType)
	end)
	
	wait()

	if ok and response and response ~= "" then
		return response
	else
		if not ok then
			warn(response)
		elseif response == "" then
			warn("Empty response returned")
		end
		return nil
	end
end

-- establish this peer as the Server
local ns = game:GetService("NetworkServer")
-- Detect cloud edit mode by checking bool from arbiter
local isCloudEdit = {teamcreate}
-- Configure CloudEdit saving after place has been loaded
if isCloudEdit then
	if testing then
		warn("Configuring as CloudEdit Server")
	end
	local doPeriodicSaves = true
	local delayBetweenSavesSeconds = 5 * 60 -- 5 minutes
	local function periodicSave()
		if doPeriodicSaves then
			warn("Saving place!")
			game:Save(saveUrl)
			delay(delayBetweenSavesSeconds, periodicSave)
		end
	end
	-- Spawn thread to save in the future
	delay(delayBetweenSavesSeconds, periodicSave)
	-- Hook into OnClose to save on shutdown
	game.OnClose = function()
		doPeriodicSaves = false
		warn("Saving place!")
		game:Save(saveUrl)
		-- yield so that file save happens in the heartbeat thread
		wait()
	end
	ns:ConfigureAsCloudEditServer()
else
	game.OnClose = function()
		warn("Server is shutting down!")
		game:HttpGet(url .. "/api/gameservers/close?jobID="..jobId .. "&access="..access)
	end
end

local badgeUrlFlagExists, badgeUrlFlagValue = pcall(function () return settings():GetFFlag("NewBadgeServiceUrlEnabled") end)
local newBadgeUrlEnabled = badgeUrlFlagExists and badgeUrlFlagValue
if url~=nil then
	if testing then
		warn("Loading NetworkServer and data")
	end
	local apiProxyUrl = "http://arl." .. baseUrl -- baseUrl is really the domain

	pcall(function() game:GetService("Players"):SetAbuseReportUrl(url .. "/AbuseReport/InGameChatHandler.ashx") end)
	pcall(function() game:GetService("ScriptInformationProvider"):SetAssetUrl(assetGameUrl .. "/Asset/") end)
	pcall(function() game:GetService("ContentProvider"):SetBaseUrl(url .. "/") end)
	pcall(function() game:GetService("Players"):SetChatFilterUrl(assetGameUrl .. "/Game/ChatFilter.ashx") end)
	
	if gameCode then
		game:SetVIPServerId(tostring(gameCode))
	end

	game:GetService("BadgeService"):SetPlaceId(placeId)

	if newBadgeUrlEnabled then
		game:GetService("BadgeService"):SetAwardBadgeUrl(apiProxyUrl .. "/assets/award-badge?userId=%d&badgeId=%d&placeId=%d")
	end

	if access ~= nil then
		if not newBadgeUrlEnabled then
			game:GetService("BadgeService"):SetAwardBadgeUrl(assetGameUrl .. "/Game/Badge/AwardBadge.ashx?UserID=%d&BadgeID=%d&PlaceID=%d")
		end

		game:GetService("BadgeService"):SetHasBadgeUrl(assetGameUrl .. "/Game/Badge/HasBadge.ashx?UserID=%d&BadgeID=%d")
		game:GetService("BadgeService"):SetIsBadgeDisabledUrl(assetGameUrl .. "/Game/Badge/IsBadgeDisabled.ashx?BadgeID=%d&PlaceID=%d")

		game:GetService("FriendService"):SetMakeFriendUrl(assetGameUrl .. "/Game/CreateFriend?firstUserId=%d&secondUserId=%d")
		game:GetService("FriendService"):SetBreakFriendUrl(assetGameUrl .. "/Game/BreakFriend?firstUserId=%d&secondUserId=%d")
		game:GetService("FriendService"):SetGetFriendsUrl(assetGameUrl .. "/Game/AreFriends?userId=%d")
	end
	game:GetService("BadgeService"):SetIsBadgeLegalUrl("")
	game:GetService("InsertService"):SetBaseSetsUrl(assetGameUrl .. "/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
	game:GetService("InsertService"):SetUserSetsUrl(assetGameUrl .. "/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d")
	game:GetService("InsertService"):SetCollectionUrl(assetGameUrl .. "/Game/Tools/InsertAsset.ashx?sid=%d")
	game:GetService("InsertService"):SetAssetUrl(assetGameUrl .. "/Asset/?id=%d")
	game:GetService("InsertService"):SetAssetVersionUrl(assetGameUrl .. "/Asset/?assetversionid=%d")
	
	if gameCode then
		pcall(function() loadfile(assetGameUrl .. "/Game/LoadPlaceInfo.ashx?PlaceId=" .. placeId .. "&gameCode=" .. tostring(gameCode))() end)
	else
		pcall(function() loadfile(assetGameUrl .. "/Game/LoadPlaceInfo.ashx?PlaceId=" .. placeId)() end)
	end
	
	pcall(function() 
				if access then
					loadfile(assetGameUrl .. "/Game/PlaceSpecificScript.ashx?PlaceId=" .. placeId .. "&access=" .. access)()
				end
			end)
end

pcall(function() game:GetService("NetworkServer"):SetIsPlayerAuthenticationRequired(false) end)
settings().Diagnostics.LuaRamLimit = 0

game:GetService("Players").PlayerAdded:connect(function(player)
	shouldCountDown = false
	
	if assetGameUrl and access and placeId and player and player.userId then
		print("Player " .. player.userId .. " added")
		local userid = string.gsub(tostring(player.userId), "%-", "")
		userid = string.gsub(tostring(player.userId), "-", "")
		player.CharacterAppearance = "http://arl.lambda.cam/Asset/CharacterFetch.ashx?userId=" .. userid .. "&placeId=" .. placeId
		if testing then
			local allowed = false
			
			for _, id in ipairs(whitelist) do
				if player.UserId == id then
					allowed = true
					break
				end
			end
			
			if not allowed then
				return player:Kick("You cannot join this server because this game is private.")
			end
		end
		local didTeleportIn = "False"
		if player.TeleportedIn then didTeleportIn = "True" end
		
		if testing then
			warn("Validating " .. player.Name)
		end

		local playerResult = game:HttpGet(url .. "/api/gameservers/validateplayer?jobID="..jobId .. "&access="..access.."&userID=" .. tostring(userid), true)
		
		if playerResult ~= "OK" then
			warn("Kicking " .. player.Name .. " because invalid")
			player:Kick("This game has shut down")
		end
		
		player.Chatted:connect(function(msg)
			onChatted(msg, player)
		end)
		player.CharacterAdded:connect(function(character)
			--[[player.CharacterAppearanceLoaded:wait()
            for _, accessory in ipairs(character:GetChildren()) do
                if accessory:IsA("Accoutrement") then
                    local success, reason = _G.validateHat({accessory})
                    if not success then
                        warn("Kicking " .. player.Name .. " due to invalidation: " .. reason)
                        player:Kick("This game has shut down")
                        return
                    else
						if testing then
							print(player.Name .. " passed validation")
						end
					end
                end
            end--]]
			spawn(function()
					waitForAccoutrement(character)
					for _, accessory in ipairs(character:GetChildren()) do
						if accessory:IsA("Accoutrement") then
							local success, reason = _G.validateHat({accessory})
							if not success then
								warn("Kicking " .. player.Name .. " due to invalid hat: " .. reason)
								player:Kick("This game has shut down")
								return
							end
						end
					end
					waitForClothing(character)

						for _, clothing in ipairs(character:GetChildren()) do
							if clothing:IsA("Shirt") or clothing:IsA("Pants") or clothing:IsA("ShirtGraphic") then
								local success, reason = _G.validateClothing({clothing})
								if not success then
									warn("Kicking " .. player.Name .. " due to invalid clothing: " .. reason)
									player:Kick("This game has shut down")
									return
								end
							end
						end
						if testing then
							warn(player.Name .. " passed validation")
						end
				end)
			
			local starterPlayer = game:GetService("StarterPlayer")

			local starterCharacter = starterPlayer:FindFirstChild("StarterCharacter")
			local folders = starterPlayer:WaitForChild("StarterCharacterScripts")

			local soundScript = character:WaitForChild("Sound")

			if folders:FindFirstChild("Sound") then
				soundScript:Remove()
			end

			local animateScript = character:WaitForChild("Animate")

			if folders:FindFirstChild("Animate") then
				animateScript:Remove()
			end

			for _, v in pairs(folders:GetChildren()) do
				v:Clone().Parent = character
			end

			starterCharacter = false

			if starterCharacter then
				for _, v in pairs(character:GetChildren()) do
					if v.Name ~= "HumanoidRootPart" and not v:IsA("LocalScript") and not v:IsA("Script") and not v:IsA("BasePart") and not v:IsA("Humanoid") then
						v:Remove()
					end
				end
				for _, v in pairs(starterCharacter:GetChildren()) do
					
					if v.Name ~= "HumanoidRootPart" and not v:IsA("BasePart") and not v:IsA("Humanoid") then
						v:Clone().Parent = character
					end
				end
			end
			
			if game:GetService("Players").EmoteSoundsEnabled then
				Instance.new("Sound", character:WaitForChild("Torso")).Name = "EmoteSounderEffect"
			end
		end)
	end
end)

game:GetService("Players").PlayerRemoving:connect(function(player)
	local isTeleportingOut = "False"
	if player.Teleported then isTeleportingOut = "True" end

	if assetGameUrl and access and placeId and player and player.userId then
		print("Player " .. player.userId .. " leaving")	
		if testing then
			warn("Removing " .. player.Name .. " from database")
		end
		game:HttpGet(url .. "/api/gameservers/removeplayer?jobID="..jobId .. "&access="..access.."&userID=" .. tostring(player.userId))
		if #game:GetService("Players"):GetPlayers() == 0 then
			if isCloudEdit then
				warn("Saving place!")
				game:Save(saveUrl)
				-- yield so that file save happens in the heartbeat thread
				wait()
			end
			
			warn("Server is being shutdown!")
			game:HttpGet(url .. "/api/gameservers/close?jobID="..jobId .. "&access="..access)
		end
	end
end)

local onlyCallGameLoadWhenInRccWithAccessKey = newBadgeUrlEnabled
if placeId ~= nil and assetGameUrl ~= nil and ((not onlyCallGameLoadWhenInRccWithAccessKey) or access ~= nil) then
	-- yield so that file load happens in the heartbeat thread
	wait()
	
	-- load the game
	game:Load(assetGameUrl .. "/asset/?id=" .. placeId)
end

-- Now start the connection
ns:Start(port, sleeptime) 

if timeout then
	scriptContext:SetTimeout(timeout)
end
scriptContext.ScriptsDisabled = false

-- FilteringEnabled Detection
local FilteringEnabled = workspace.FilteringEnabled
if not FilteringEnabled then
	warn("This place doesn't use FilteringEnabled. This means your place is vulnerable to exploits. You should turn it on.")
end

-- StartGame --
if not isCloudEdit then
	if injectScriptAssetID and (injectScriptAssetID < 0) then
		pcall(function() Game:LoadGame(injectScriptAssetID * -1) end)
	else
		pcall(function() Game:GetService("ScriptContext"):AddStarterScript(injectScriptAssetID) end)
	end
	
	if game:GetService("Players").EmoteSoundsEnabled then
		local emoteEvent = game:GetService("ReplicatedStorage"):FindFirstChild("ANORRLEMOTEEVENTERTHING")
		if not emoteEvent then
			emoteEvent = Instance.new("RemoteEvent", game:GetService("ReplicatedStorage"))
			emoteEvent.Name = "ANORRLEMOTEEVENTERTHING"
		end

		emoteEvent.OnServerEvent:connect(function(player, emoteName, state)
			if player.Character then
				local emoteSounder = player.Character:WaitForChild("Torso"):FindFirstChild("EmoteSounderEffect")
				if not emoteSounder then
					emoteSounder = Instance.new("Sound", player.Character:WaitForChild("Torso"))
					emoteSounder.Name = "EmoteSounderEffect"
				end
				
				emoteSounder.Volume = 0.5
				emoteSounder.Looped = true
				emoteSounder:Stop()

				local emoteSounds = { -- grace please consider taking lua classes
					californiagurls = "rbxassetid://527",
					dwyec = "rbxassetid://535",
					caramelldansen = "rbxassetid://533",
					awakening = "rbxassetid://107",
					unlockit = "rbxassetid://1316",
					otsukare = "rbxassetid://1318",
					hakari = "rbxassetid://1381",
					mannrobics = "rbxassetid://1383",
					gangnam = "rbxassetid://2136",
					gmod = "rbxassetid://2140",
					cryforme = "rbxassetid://3239",
					jumpstyle = "rbxassetid://7455",
					awesomeface = "rbxassetid://7500",
          creeper = "rbxassetid://7567"
				}

				if state == "play" then
					local soundId = emoteSounds[emoteName]

					if soundId then
						emoteSounder.SoundId = soundId
						wait()
						emoteSounder:Play()
					else
						emoteSounder:Stop()
					end
				end
			end
		end)
	end
	
	-- filteringenabled warning

	Game:GetService("RunService"):Run()
end

-- Heartbeat --
while wait(1) do
	if shouldCountDown then
		countdownTimer = countdownTimer - 1

		if shouldCountDown and countdownTimer <= 0 then
			warn("Server is being shutdown!")
			if isCloudEdit then
				warn("Saving place!")
				game:Save(saveUrl)
				-- yield so that file save happens in the heartbeat thread
				wait()
			end
			game:HttpGet(url .. "/api/gameservers/close?jobID="..jobId .. "&access="..access)
			break
		end
	end
	if not isCloudEdit and workspace.FilteringEnabled ~= FilteringEnabled then
		warn("Something tried to change FilteringEnabled! Reverting...")
		workspace.FilteringEnabled = FilteringEnabled
	end
end
