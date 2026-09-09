----------------------== GAMESERVER SCRIPT ==----------------------
--[[
	@creator ANORRL
	@author KURO (2026)
]]

-- move these values into arbiter??
local placeId, port, sleeptime, timeout, domain, universeId, protocol, jobId, isCloudEdit, testing =
{requestId}, {port}, 10, 10, "{domain}", {universeId}, "https://", "{jobId}", {teamcreate}, false

-------== CONSTANTS ==-------
local url = protocol .. domain
local startingTimer = 15
local renewSeconds = 25
local delayBetweenSavesSeconds = 5 * 60 -- 5 minutes (cloud server save interval)

local Players = game:GetService("Players")
local ApiService = game:GetService("HttpRbxApiService")

----------------------== START SETUP OF SERVICES AND SHIT ==----------------------
local ScriptContext = game:GetService("ScriptContext")
local BadgeService  = game:GetService("BadgeService")
local FriendService = game:GetService("FriendService")
local InsertService = game:GetService("InsertService")

----== MISC. ==----
game:GetService("ContentProvider"):SetBaseUrl(url .. "/")
game:GetService("ChangeHistoryService"):SetEnabled(false)
game:GetService("ScriptInformationProvider"):SetAssetUrl(url .. "/asset/")
ScriptContext.ScriptsDisabled = true

----== PLAYERS ==----
Players:SetChatFilterUrl(url .. "/Game/ChatFilter.ashx")
pcall(function() Players:SetAbuseReportUrl(url .. "/AbuseReport/InGameChatHandler.ashx") end) -- requires pcall because it resets the abuse configurer completely

----== BADGESERVICE ==----
BadgeService:SetPlaceId(placeId)
BadgeService:SetIsBadgeLegalUrl("")
BadgeService:SetAwardBadgeUrl(url .. "/Game/Badge/AwardBadge.ashx?UserID=%d&BadgeID=%d&PlaceID=%d")
BadgeService:SetHasBadgeUrl(url .. "/Game/Badge/HasBadge.ashx?UserID=%d&BadgeID=%d")
BadgeService:SetIsBadgeDisabledUrl(url .. "/Game/Badge/IsBadgeDisabled.ashx?BadgeID=%d&PlaceID=%d")
----== FRIENDSERVICE ==----
FriendService:SetMakeFriendUrl(url .. "/Game/CreateFriend?firstUserId=%d&secondUserId=%d")
FriendService:SetBreakFriendUrl(url .. "/Game/BreakFriend?firstUserId=%d&secondUserId=%d")
FriendService:SetGetFriendsUrl(url .. "/Game/AreFriends?userId=%d")
----== INSERTSERVICE ==----
InsertService:SetAssetUrl(url .. "/asset/?id=%d")
InsertService:SetAssetVersionUrl(url .. "/asset/?assetversionid=%d")
InsertService:SetBaseSetsUrl(url .. "/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
InsertService:SetUserSetsUrl(url .. "/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d")
InsertService:SetCollectionUrl(url .. "/Game/Tools/InsertAsset.ashx?sid=%d")

----------------------== LUA SETTINGS STUFF ==---------------------- 
settings().Network.UseInstancePacketCache = true
settings().Network.UsePhysicsPacketCache = true
settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError -- FIFO...
settings().Network.PhysicsSend = Enum.PhysicsSendMethod.TopNErrors
settings().Network.ExperimentalPhysicsEnabled = true
settings().Network.WaitingForCharacterLogRate = 100
settings().Diagnostics.LuaRamLimit = 0

----------------------== END OF THAT STUFF! ==----------------------

local shuttingDown = false
local countdownActive = true
local countdownTimer = startingTimer

local ecCommands = {
	"ec",
	"cock",
	"raymonf",
	"gage",
	"minecraft",
	"suicide",
	"energycell",
	"cancer",
	"bleach",
	"sex",
	"kms",
	"death",
	"robloxsuckingpenis",
	"korone",
	"austiblox",
	"pekora",
	"liam",
	"amir",
	"brickplanet",
	"polytoriacrashed",
	"wm",
	"underscores",
	"headlock"
}
local arbysChibkenSound = 256
local retroSound = 453
local elivSound = 255
local ecSounds = {63,66,68,252,253,254,451,452}

------------== UTILITY FUNCTIONS ==------------
local function logInfo(...) if testing then print(...) end end
local function logWarn(...) if testing then warn(...)  end end
local function logErr(...)  if testing then err(...)   end end

local function doSavePlace()
	if not isCloudEdit then return end
	-- wait() -- im not sure if i should do this?
	local response, result = pcall(function() game:Save(url .. "/Data/Upload.ashx?assetid=" .. placeId) end)
	if not response then logWarn(result) end
end

local function renewThread()
	if shuttingDown then return end
	ApiService::PostAsync("/server/"..jobId.."/renew", "", true)
	delay(renewSeconds, renewThread)
end

local function shutdown()
	warn("Server is being shutdown!")
	doSavePlace()
	ApiService::PostAsync("/server/"..jobId.."/close", "", true)
end

-- PlayOnRemove?
local function playStupidSound(id, target, volume)
	local sound = Instance.new("Sound")
	sound.Parent = head
	if volume then sound.Volume = volume end
	sound.SoundId = "arlassetid://" .. id
	wait()
	sound:Play()
end
------------== END UTILITY FUNCTIONS ==------------

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
			wait()
			game:GetService("TeleportService"):Teleport(game.PlaceId, speaker)
		end)
		return
	end
	
	if humanoid.Health > 0 then
		if msg:sub(1, 1) == ";" then
			local command = msg:sub(2)
			if command == "eliv" then
				humanoid.Health = 0
				playStupidSound(elivSound, head)
			else
				for i = 1, #ecCommands do
					if command == ecCommands[i] then
						playStupidSound(ecSounds[math.random(1, #ecSounds), head)
						break -- there's no need to keep going if we already found it
					end
				end
			end
		else
			if msg == "!!!reset" then
				humanoid.Health = 0
			elseif msg == "retro" or msg == "retr0" then
				humanoid.Health = 0
				playStupidSound(retroSound, head)
			elseif msg == "arbys chibken" and Players.ArbysChibkenEnabled and torso then
				playStupidSound(arbysChibkenSound, head, 0.5)
				
				wait(2)
				humanoid.Health = 0
				local explosion = Instance.new("Explosion")
				explosion.Position = torso.Position
				explosion.Parent = workspace
			end
		end
	end
end

game:SetPlaceID(placeId, true)
-- need this for like arlgameasset:// stuff
game:SetUniverseId(universeId)

-- establish this peer as the Server
local NetworkServer = game:GetService("NetworkServer") -- i wonder if it matters what order this is placed?
NetworkServer:SetIsPlayerAuthenticationRequired(true) -- requires proper clienttickets!

-- Configure CloudEdit saving after place has been loaded
if isCloudEdit then
	logInfo("Configuring as CloudEdit Server")
	NetworkServer:ConfigureAsCloudEditServer()

	-- set up periodic saves thread loop --
	local doPeriodicSaves = true
	local function periodicSave()
		if not doPeriodicSaves or shuttingDown then return end
		doSavePlace()
		delay(delayBetweenSavesSeconds, periodicSave)
	end
	delay(delayBetweenSavesSeconds, periodicSave)
	
	game.OnClose = function()
		doPeriodicSaves = false
		doSavePlace()
	end
else
	game.OnClose = function()
		logWarn("Server is shutting down!")
		ApiService::PostAsync("/server/"..jobId.."/close", "", true)
	end
end

if gameCode then game:SetVIPServerId(tostring(gameCode)) end

Players.PlayerAdded:Connect(function(player)
	if player.userId < 1 then return player:Kick() end  -- fuck off much?
	
	local didTeleportIn = "false"
	if player.TeleportedIn then didTeleportIn = "true" end
	
	logInfo("Validating " .. player.Name)

	local playerResult = ApiService::PostAsync("/server/"..jobId.."/validate/"..player.userId.."?teleported="..didTeleportIn, "", true) -- process json
	if playerResult ~= "OK" then
		logWarn("Kicking " .. player.Name .. ":" .. player.userId .. " because invalid")
		return player:Kick("This game has shut down")
	end
	logInfo("Player " .. player.Name .. ":" .. player.userId .. " added")
	
	-- disable and reset timer if a player joins successfully
	countdownTimer = startingTimer
	countdownActive = false
	
	player.Chatted:connect(function(msg) onChatted(msg, player) end)
end)

Players.PlayerRemoving:Connect(function(player)
	local isTeleportingOut = "false"
	if player.Teleported then isTeleportingOut = "true" end
	
	logInfo("Player " .. player.Name ..":" .. player.userId .. " leaving.")
	ApiService::PostAsync("/server/"..jobId.."/remove/"..player.userId.."?teleport="..didTeleportIn, "", true) 
	
	-- begin timer if the server is empty
	countdownActive = #Players:GetPlayers() == 0
end)

wait()                                -- yield so that file load happens in the heartbeat thread
game:Load("arlassetid://" .. placeId) -- load the game
NetworkServer:Start(port, sleeptime)  -- Now start the server

ScriptContext:SetTimeout(timeout)
ScriptContext.ScriptsDisabled = false

if not workspace.FilteringEnabled then
	warn("This place doesn't use FilteringEnabled. This means your place is vulnerable to exploits. You should turn it on.")
end

-----== SETUP EMOTE MUSIC ==-----
if not isCloudEdit then
	if Players.EmoteSoundsEnabled then
		-- move to c++ ??? or at least improve this or something...
		local emoteEvent = game:GetService("ReplicatedStorage"):FindFirstChild("ANORRLEMOTEEVENTERTHING")
		if not emoteEvent then
			emoteEvent = Instance.new("RemoteEvent", game:GetService("ReplicatedStorage"))
			emoteEvent.Name = "ANORRLEMOTEEVENTERTHING"
		end

		emoteEvent.OnServerEvent:connect(function(player, emoteName, state)
			if player.Character then
				-- Implement EmoteSound (with seperate fmod channel)
				local emoteSounder = player.Character:WaitForChild("Torso"):FindFirstChild("EmoteSounderEffect")
				if not emoteSounder then
					emoteSounder = Instance.new("Sound", player.Character:WaitForChild("Torso"))
					emoteSounder.Name = "EmoteSounderEffect"
					emoteSounder.Looped = true
					emoteSounder.Volume = 0.5
				end
				emoteSounder:Stop()
				
				-- probably should move this to an api?
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
end

if isCloudEdit then game:GetService("RunService"):Stop() else game:GetService("RunService"):Run() end

---== Heartbeat ==---
-- Runs every second, used for server inactivity (if no players then countdown and die!!!)
local function serverHeartbeat()
	if shuttingDown then return end
	if countdownActive then
		countdownTimer -= 1
		shuttingDown = countdownTimer <= 0 and #Players:GetPlayers() == 0
		if shuttingDown then shutdown() return end
	end
	delay(1, serverHeartbeat)
end

--== SETUP ITERATIVE THREADS ==--
delay(1, serverHeartbeat)
delay(renewSeconds, renewThread)

----------------------== END OF SCRIPT ==----------------------
