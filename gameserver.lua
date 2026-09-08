-- TODO:
-- - add renewlease time to arguments
-- - rename renewlease api to renew
-- - create api subdomain
-- - make a GOOD logging system for this script in particular...
-- - move every api request to HttpRbxApiService and POST. (web requires post!)

-- Start Game Script Arguments
local placeId, port, sleeptime, timeout, domain, libraryRegistrationScriptAssetID, universeId, protocol, jobId, isCloudEdit, testing =
{requestId}, {port}, 10, 10, "{domain}", 37801172, {universeId}, "https://", "{jobId}", {teamcreate}, false

-----------------------------------"CUSTOM" SHARED CODE----------------------------------
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ApiService = game:GetService("HttpRbxApiService")
local scriptContext = game:GetService('ScriptContext')

settings().Network.UseInstancePacketCache = true
settings().Network.UsePhysicsPacketCache = true
settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError -- FIFO...
settings().Network.PhysicsSend = Enum.PhysicsSendMethod.TopNErrors
settings().Network.ExperimentalPhysicsEnabled = true
settings().Network.WaitingForCharacterLogRate = 100
settings().Diagnostics.LuaRamLimit = 0
-- LegacyScriptMode was just an empty function (DebugSettings::noOpt)

-- this will never be nil.
local url = protocol .. domain
local saveUrl = nil
if isCloudEdit then
	saveUrl = url .. "/Data/Upload.ashx?assetid=" .. placeId
end

local shuttingDown = false
local shouldCountDown = true
local startingTimer = 15
local countdownTimer = startingTimer

local commands = {";ec", ";cock", ";raymonf", ";gage", ";minecraft", ";suicide", ";energycell", ";cancer", ";bleach", ";sex", ";kms", ";death", ";robloxsuckingpenis", ";korone", ";austiblox", ";pekora", ";liam", ";amir", ";brickplanet", ";polytoriacrashed", ";wm"}

local arbysChibkenSound = 256
local retroSound = 453
local elivSound = 255
local ecSounds = {63,66,68,252,253,254,451,452}

-- PlayOnRemove?
local function playStupidSound(id, target, volume)
	local sound = Instance.new("Sound")
	sound.Parent = head
	sound.SoundId = "arlassetid://" .. id
	if not volume then
		--sound.Volume = 0.5
	else
		sound.Volume = volume
	end
	wait()
	sound:Play()
end

local function onChatted(msg, speaker)
	msg = string.lower(msg)

	local character = speaker.Character
	if not character then return end

	local humanoid = character:FindFirstChild("Humanoid")
	local head = character:FindFirstChild("Head")
	local torso = character:FindFirstChild("Torso")
	if not humanoid or not head then return end

	if msg == "!rejoin" then
		spawn(function()
			wait(0.2)
			TeleportService:Teleport(game.PlaceId, speaker)
		end)
		return
	end
	
	if humanoid.Health > 0 then
		if msg == "!!!reset" then
			humanoid.Health = 0
			return
		end
		
		for i = 1, #commands do
			if msg == commands[i] then
				humanoid.Health = 0
				playStupidSound(ecSounds[math.random(1, #ecSounds), head)
			end
		end
		
		if msg == ";eliv" then
			humanoid.Health = 0
			playStupidSound(elivSound, head)
		elseif msg == "retro" then
			humanoid.Health = 0
			playStupidSound(retroSound, head)
		end
	end


	if Players.ArbysChibkenEnabled and msg == "arbys chibken" and torso then
		playStupidSound(arbysChibkenSound, head, 0.5)
		
		wait(2)
		
		local explosion = Instance.new("Explosion")
		explosion.Position = torso.Position
		explosion.Parent = workspace
	end
end

Players.PlayerAdded:connect(function(player)
	player.Chatted:connect(function(msg)
		onChatted(msg, player)
	end)
end)

if (placeId == 3724) then
	warn("Testing enabled")
	testing = true
end

-----------------------------------START GAME SHARED SCRIPT------------------------------

-- use groups instead?
local whitelist = { 1, 43, 62 }


pcall(function() scriptContext:AddStarterScript(libraryRegistrationScriptAssetID) end)
scriptContext.ScriptsDisabled = true

-- SetPlaceID(int placeID, bool anorrlPlace)
-- setting this to true assigns any loaded corescript to be the security of GameScriptInANORRLPlace_ (which allows ANORRLPlace permissions to be bypassed)
-- might fix the modules issue if anorrlplace is true?
game:SetPlaceID(placeId, true)
if universeId ~= nil then game:SetUniverseId(universeId) end
game:GetService("ChangeHistoryService"):SetEnabled(false)

-- establish this peer as the Server
local ns = game:GetService("NetworkServer")
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
			local response, result = pcall(function() game:Save(saveUrl) end)
			if not response then
				warn(result)
			end
			delay(delayBetweenSavesSeconds, periodicSave)
		end
	end
	-- Spawn thread to save in the future
	delay(delayBetweenSavesSeconds, periodicSave)
	-- Hook into OnClose to save on shutdown
	game.OnClose = function()
		doPeriodicSaves = false
		warn("Saving place!")
		local response, result = pcall(function() game:Save(saveUrl) end)
		if not response then
			warn(result)
		end
		-- yield so that file save happens in the heartbeat thread
		wait()
	end
	ns:ConfigureAsCloudEditServer()
else
	game.OnClose = function()
		warn("Server is shutting down!")
		game:HttpGet(url .. "/server/"..jobId.."/close")
	end
end

if testing then
	warn("Loading NetworkServer and data")
end

pcall(function() Players:SetAbuseReportUrl(url .. "/AbuseReport/InGameChatHandler.ashx") end)
pcall(function() game:GetService("ScriptInformationProvider"):SetAssetUrl(url .. "/Asset/") end)



if gameCode then
	game:SetVIPServerId(tostring(gameCode))
end
Players:SetChatFilterUrl(url .. "/Game/ChatFilter.ashx")

game:GetService("ContentProvider"):SetBaseUrl(url .. "/")

game:GetService("BadgeService"):SetPlaceId(placeId)
game:GetService("BadgeService"):SetIsBadgeLegalUrl("")
game:GetService("BadgeService"):SetAwardBadgeUrl(url .. "/Game/Badge/AwardBadge.ashx?UserID=%d&BadgeID=%d&PlaceID=%d")
game:GetService("BadgeService"):SetHasBadgeUrl(url .. "/Game/Badge/HasBadge.ashx?UserID=%d&BadgeID=%d")
game:GetService("BadgeService"):SetIsBadgeDisabledUrl(url .. "/Game/Badge/IsBadgeDisabled.ashx?BadgeID=%d&PlaceID=%d")

game:GetService("FriendService"):SetMakeFriendUrl(url .. "/Game/CreateFriend?firstUserId=%d&secondUserId=%d")
game:GetService("FriendService"):SetBreakFriendUrl(url .. "/Game/BreakFriend?firstUserId=%d&secondUserId=%d")
game:GetService("FriendService"):SetGetFriendsUrl(url .. "/Game/AreFriends?userId=%d")

game:GetService("InsertService"):SetBaseSetsUrl(url .. "/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
game:GetService("InsertService"):SetUserSetsUrl(url .. "/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d")
game:GetService("InsertService"):SetCollectionUrl(url .. "/Game/Tools/InsertAsset.ashx?sid=%d")
game:GetService("InsertService"):SetAssetUrl(url .. "/asset/?id=%d")
game:GetService("InsertService"):SetAssetVersionUrl(url .. "/asset/?assetversionid=%d")

-- i think a reason this was originally in pcall was because of compatibility.
-- source wise, there's no yielding or anything. it's just a boolean set with nothing else.
-- requires proper clienttickets tho!
ns:SetIsPlayerAuthenticationRequired(true)

Players.PlayerAdded:Connect(function(player)
	shouldCountDown = false
	
	-- huh
	if player and player.userId then
		print("Player " .. player.userId .. " added")
		
		if player.userId < 1 then
			return player:Kick() -- fuck off much?
		end
		
		-- why are we setting this?
		player.CharacterAppearance = url .. "/Asset/CharacterFetch.ashx?userId=" .. player.userId .. "&placeId=" .. placeId
		
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
		
		local didTeleportIn = "false"
		if player.TeleportedIn then didTeleportIn = "true" end
		
		if testing then
			warn("Validating " .. player.Name)
		end

		-- rewrite with HttpRbxApiService
		local playerResult = game:HttpGet(url .. "/server/"..jobId.."/validate/" .. tostring(userid) .. "?teleported=" .. didTeleportIn, true)
		
		if playerResult ~= "OK" then
			if testing then
				warn("Kicking " .. player.Name .. " because invalid")
			end
			return player:Kick("This game has shut down")
		end
		
		-- reset timer if a player joins.
		countdownTimer = startingTimer
		
		if not player:FindFirstChild("HandleEmote") then
			Instance.new("BindableEvent", player).Name = "HandleEmote"
		end
		
		-- player character stuff is fixed with FFlags...
		--[[ SPECIFICALLY:
						DFFlagUseStarterPlayer
						DFFlagUseStarterPlayerCharacter
						DFFlagUseStarterPlayerCharacterScripts
						DFFlagUseStarterPlayerHumanoid
		THESE MUST BE ENABLED! ]]
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local isTeleportingOut = "false"
	if player.Teleported then isTeleportingOut = "true" end

	print("Player " .. player.userId .. " leaving")	
	if testing then
		warn("Removing " .. player.Name .. " from database")
	end
	game:HttpGet(url .. "/server/" .. jobId .. "/remove/" .. player.userId .. "?teleport="..isTeleportingOut)
	
	-- begin timer if the server is empty
	shouldCountDown = #Players:GetPlayers() == 0
end)

-- yield so that file load happens in the heartbeat thread
wait()

-- load the game
game:Load("arlassetid://" .. placeId)

-- Now start the connection
ns:Start(port, sleeptime) 

if timeout then
	scriptContext:SetTimeout(timeout)
end
scriptContext.ScriptsDisabled = false

if not workspace.FilteringEnabled then
	warn("This place doesn't use FilteringEnabled. This means your place is vulnerable to exploits. You should turn it on.")
end

if injectScriptAssetID and (injectScriptAssetID < 0) then
	pcall(function() Game:LoadGame(injectScriptAssetID * -1) end)
else
	pcall(function() scriptContext:AddStarterScript(injectScriptAssetID) end)
end

-- StartGame --
if not isCloudEdit then
	
	if Players.EmoteSoundsEnabled then
		-- this could be done better...
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

				local emoteSounds = {
					californiagurls = "arlassetid://257",
					dwyec = "arlassetid://258",
					caramelldansen = "arlassetid://259",
					awakening = "arlassetid://261",
					unlockit = "arlassetid://260",
					otsukare = "arlassetid://262",
					hakari = "arlassetid://263",
					mannrobics = "arlassetid://264",
					gangnam = "arlassetid://265",
					gmod = "arlassetid://266",
					jumpstyle = "arlassetid://267",
					awesomeface = "arlassetid://268",
					creeper = "arlassetid://269",
					rampage = "arlassetid://275"
				}
				-- no else statement???
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

	game:GetService("RunService"):Run()
else
	game:GetService("RunService"):Stop()
end

-- this is just for renewing the job
-- increment by one, if modulus 25 == 0 then reset
-- if reset, then renew.
local timer = 0
local firstLoop = true

-- Heartbeat --
while wait(1) do
	if timer == 0 and not firstLoop then
		game:HttpGet(url .. "/server/" .. jobId .. "/renewlease")
	end

	timer += 1
	if shouldCountDown then
		countdownTimer -= 1

		if shouldCountDown and countdownTimer <= 0 and #Players:GetPlayers() == 0 then
			if testing then
				warn("Server is being shutdown!")
			end
			if isCloudEdit then
				if testing then
					warn("Saving place!")
				end
				local response, result = pcall(function() game:Save(saveUrl) end)
				if not response then
					warn(result)
				end
				-- yield so that file save happens in the heartbeat thread
				wait()
			end
			game:HttpGet(url .. "/server/"..jobId.."/close")
			break
		end
	end
	
	timer %= 25
	if firstLoop then firstLoop = false end
end
