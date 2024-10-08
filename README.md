# **DISCLAIMER**
Might not work with non-Latin characters. Should be safe, but I can't guarantee that.

# Compatibility
## Savegames:
- adding this mod to an existing savegame should be fine (tested it once, and it's intended to not break saves)
- removing the mod will make that savegame unloadable
  - if you don't want to use the mod anymore, but don't want to break the savegame, making the "channel" field blank should behave like it's been removed
## Other mods:
- compatible with legends
- should be compatible with almost anyother mod

# Features:
- Requires only channel name, no OAuth Token required
Multiple channels can be used at the same time
- Automatically names recruits, dogs, named items and enemies after chat names
  - Names get logged when anything is sent in Twitch chat
  - Names get sorted into 'Free', 'Hired', 'Dead' and 'Retired' categories
  - decide who can spawn as what (e.g. Dead/Retired can't spawn as recruits but as enemies and dogs)
  - Recruits in settlement won't spawn with the same Twitch name
  - names will get updated when entering a settlement
- Chat commands
  - multiple commands per chat message are possible
  - `!bbname <name with spaces>`
    - Set in-game name (the name is only used on new spawn). If not set, the normal twitch display name will be used.
    - Only using `!bbname` will reset the name to the twitch display name
  - `!bbtitle <title with spaces>`
    - Set in-game title (the title is only used on new spawns and only if there isn't already a title for that bro)
    - Only using `!bbtitle` clears the title.
  - `!bbclear <twitchname or @twitchname>`
    - Command for moderators and broadcaster. Will reset name and title of specified user to prevent misuse
  - `!bbblock <twitchname or @twitchname>`
    - Command for moderators and broadcaster. Will blacklist that user until the game is closed.
    - This command will automatically executed if a user gets banned in chat  
- Customizable blacklist
  - uses regular expressions
  - not working retroactive
  - option to auto blacklist common twitch bots
  - Custom names and titles will discarded if they contain an expression from the blacklist
- Chat votes for event screens
  - Selection modes:
    - Manuel: show the vote count and highlight the highest voted option
    - Auto: Start a timer after the first vote is received and select the highest voted option, randomized on tie
    - Both: Allow manual selection to override auto select
  - Customize event vote duration, selection animations and highlight colors
 
# Requirements
- MSU: https://www.nexusmods.com/battlebrothers/mods/42
  - Requires Modding script Hooks: https://www.nexusmods.com/battlebrothers/mods/479
- Modern Hooks: https://www.nexusmods.com/battlebrothers/mods/685
- Optional (needed if you want to save mod settings; please read their description on how to use it properly)
  - BBParser: https://github.com/MSUTeam/BBParser/wiki/BBParser

# Changelog:

## 0.1.0
- init
- Start characters and recruitable characters get names from Twitch viewers that send any message in chat

## 0.2.0
- Customizable blacklist
- Custom names
- Viewers are unique

## 0.2.1
- added chat commands: !bbtitle, !bbclear, !bbblock
- Custom names and titles will be discarded if they contain an expression from the blacklist
- Remove special characters from custom names and titles. Removed characters: `|&;$%@"'<>()+,.:{}[]`

## 0.2.2
- character names of recruits in settlement get updated when entering a settlement
- added setting to customize commands and spawn options
- tooltip of hired brothers show their twitch name (to identify people with custom names)
- Editing player names in-game now doesn't automatically add the linked twitch names for respawn (unlinking the twitch names will be added when some kind of name reroll mechanic is added)
- fixed: removing of special characters didn't work
- fixed: on loading a game, characters that were already hired/dead/retired could spawn because they weren't removed from the free name list
- fixed: descriptions weren't always properly build when setting a Twitch name

## 0.3.0
- dogs can spawn with chat name
- named items can spawn with chat name
- some elite enemies can spawn with chat name
- fixed: couldn't enter settlement because a setting couldn't be properly accessed

## 0.3.1
- fixed: named items(with character names) were sometimes not properly named
- fixed: some enemies could produce errors because troop/type weren't properly set

## 0.4.0
- implemented new character naming screen
  - update custom Twitch names in game
  - ban TwitchIDs in game
  - reroll TwitchIDs
- minor bugfixes and improvements  

## 0.4.1
- fixed typos
- added tooltips
  - TwitchID tooltip now shows partial matches of tracked IDs
- removed junk files from release

## 0.4.2
- empty !bbname and !bbtitle commands clear the saved names/titles (for the person using that command)
- fixed 'Morderatz-Bug': twitch user without a twitch badge couldn't use the use the chat commands
- fixed: when giving a recruitable bro a new twitch name (happens on entering settlement) the title wasn't properly deleted/restored/changed

## 0.5.0
- implemented chat event votes
- fixed: the game would crash on start when certain settings were set
