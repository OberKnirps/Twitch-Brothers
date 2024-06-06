::TwitchBrothers.Content.hook_character_screen <- function()
{
	::TwitchBrothers.Mod.hook("scripts/ui/screens/character/character_screen", function ( q ) 
	{
		q.onDismissCharacter = @(__original) function (_data)
		{
			::Const.TwitchInterface.twitchIDToNamePool(this.Tactical.getEntityByID(_data[0]).m.TwitchID,::Const.TwitchInterface.m.TwitchNames.Retired);
			__original(_data);
		}
	});
}