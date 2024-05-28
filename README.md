# **DISCLAIMER**
Might not work with non Latin characters. Should be safe but I can't gurantee that.

# Feature:
- Start characters and recuitable characters get names from twitch viewers that send any message in chat
- Requires only channel name, no OAuth Token required
  - multiple channels kann be used at the same time
- Viewer can set a custom name for them self with `!bbname <name with spaces>`
- Chat commands
  - `!bbname <name with spaces>`
    - Set ingame name (name is only used on new spawn). If not set the normal twitch name will be used 
  - `!bbtitle <title with spaces>`
    - Set ingame title (title is only used on new spawn and only if there isnt already a title for thath bro)
  - `!bbclear <twitchname or @twitchname>`
    - Command for moderators and broadcaster. Will reset name and title of specified user to prevent misuse
  - `!bbblock <twitchname or @twitchname>`
    - Command for moderators and broadcaster. Will blacklist that user until the game is closed.
    - This command will automaticaly executed if a user gets banned in chat  
- Customizable blacklist
  - uses regular expressions
  - not working retroactive
  - option to auto blacklist common twitch bots
  - Custom names and titles will discarded if they contain an expression from the blacklist
- Viewers are unique
  - Every viewer can only spawn once per settlement
  - Dead, hired or retired/dismissed viewers cant spawn
 
# Requirements
- MSU: https://www.nexusmods.com/battlebrothers/mods/42
  - Requires Modding script Hooks: https://www.nexusmods.com/battlebrothers/mods/479
- Modern Hooks: https://www.nexusmods.com/battlebrothers/mods/685
- Optional \(needed if you want to save mod settings please read their description\)
  - BBParser: https://github.com/MSUTeam/BBParser/wiki/BBParser

# Changelog:

## 0.1.0
- init
- Start characters and recuitable characters get names from twitch viewers that send any message in chat

## 0.2.0
- Customizable blacklist
- Custom names
- Viewers are unique

## 0.2.1
- added chat commands: !bbtitle, !bbclear, !bbblock
- Custom names and titles will discarded if they contain an expression from the blacklist
- Remove special characters from custom names and titels. Removed characters: `|&;$%@"'<>()+,.:{}[]`
