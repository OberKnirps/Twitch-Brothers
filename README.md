# Feature:
- Start characters and recuitable characters get names from twitch viewers that send any message in chat
- Requires only channel name, no OAuth Token required
  - multiple channels kann be used at the same time
- Viewer can set a custom name for them self with `!bbname <name with spaces>`
- Customizable blacklist
  - uses regular expressions
  - not working retroactive
  - option to auto blacklist common twitch bots
  - does not work for custom names \(will be added later\)
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
