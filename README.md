# scripts

## gamescript
### todo
- create api subdomain
- make a GOOD logging system for this script in particular...
- use close for closing jobs and terminate for terminating jobs...
- rework some server apis to use JSON.
- rework api formatting, just the url.

### notes
<hr>
#### StarterPlayer

**THESE DYNAMIC FAST FLAGS ON BOTH ACC AND CLIENT MUST BE ENABLED FOR STARTERPLAYER STUFF!**

| Flags                                  | Value |
| -------------------------------------  | ----- |
|	DFFlagUseStarterPlayer                 | `True` |
| DFFlagUseStarterPlayerCharacter	       | `True` |
| DFFlagUseStarterPlayerCharacterScripts | `True` |
| DFFlagUseStarterPlayerHumanoid	       | `True` |

#### SetPlaceID(int placeID, bool anorrlPlace)
Setting anorrlPlace to true in SetPlaceID assigns any loaded corescript to be the identity of GameScriptInANORRLPlace.

which allows ANORRLPlace reflection properties/functions to be used... (might fix the modules issue if anorrlplace is true?)

#### RunService
- There's a line in which RunService:Stop() is deliberately called when CloudEdit is enabled...
- I'm not sure if this actually fixes anything but oh well, cloud servers tend to just do physics when they shouldn't.
- Could be a studio thing to be honest...

#### DataModel.OnClose callbacks
I have no idea if this ever gets called due to how the arbiter works...

#### EmoteMusic
- I'm thinking about making a seperate channel in the soundservice for emotes
- I'm also thinking about setting up emote music in c++ instead of lua
- If not c++ then I want to rewrite it to be MUCH better...

#### Misc
LegacyScriptMode() was just an empty function (DebugSettings::noOpt)
