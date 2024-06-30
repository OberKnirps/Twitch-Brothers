::TwitchBrothers.Content.add_tooltips <- function()
{
	local myTooltips = {
		changeNameDialog = {
			updateName = ::MSU.Class.BasicTooltip("Update Name", "Get the custom name / display name of current TwitchID. Does nothing, if TwitchID is not tracked."),
			updateTitle = ::MSU.Class.BasicTooltip("Update Title", "Get the custom title of current TwitchID. Does nothing, if TwitchID is not tracked or no custom title is set."),
			inputTwitchID = ::MSU.Class.BasicTooltip("Change Twitch ID", function(_data)
			{
				local list = ::Const.TwitchInterface.lookupNamesWithSubstring(_data.twitchID.tolower());
				if(list == null)
				{
					return "[color=#800000]" + _data.twitchID + "[/color] not tracked."
				}

				//print possible matches
				local res = "";
				local match = ::Const.TwitchInterface.lookupName(_data.twitchID);
				if(match != null)
				{
					res = "[color=#008000]" + _data.twitchID + "[/color] is tracked.\n\n"
				}
				res += "Possible matches:\n"
				foreach(val in list){
					res += "[color=#800000]" + ::MSU.String.replace(val.TwitchID, _data.twitchID.tolower(),
						"[/color][color=#008000]" + _data.twitchID.tolower() + "[/color][color=#800000]", true) + "[/color] ";
					switch(val.ParentTable)
					{
						case ::Const.TwitchInterface.m.TwitchNames.Free:
							res += "is free.\n"
							break;
						case ::Const.TwitchInterface.m.TwitchNames.Hired:
							res += "is already hired.\n"
							break;
						case ::Const.TwitchInterface.m.TwitchNames.Dead:
							res += "is dead.\n"
							break;
						case ::Const.TwitchInterface.m.TwitchNames.Retired:
							res += "is retired.\n"
							break;
					}
				}
            	return (res);
        	}),
			rerollTwitchID = ::MSU.Class.BasicTooltip("Reroll Twitch ID", "Roll a new TwitchID form recruitable TwitchIDs. AFTER 'Apply' is pressed: old TwitchID gets back into free pool, new TwitchID gets into hired pool."),
			freeTwitchID = ::MSU.Class.BasicTooltip("Free Twitch ID", "Clear TwitchID (and move it back to free pool) and restore original brother name and title."),
			banTwitchID = ::MSU.Class.BasicTooltip("Ban Twitch ID", "Queues this TwitchID for banning (multiple TwitchIDs can be banned at once). Bans are only applied AFTER 'Apply' is pressed. If you want to revert a ban, go to the mod settings of twitch brothers and remove the name from the blacklist.")
		}
	}

	::TwitchBrothers.MSU.Tooltips.setTooltips(myTooltips)
}