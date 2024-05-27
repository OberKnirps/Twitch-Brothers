::TwitchBrothers.Content.hook_character_screen <- function(){
	::TwitchBrothers.Mod.hook("scripts/ui/screens/character/character_screen", function ( q ) {
		q.onDismissCharacter = @(__original) function (_data){
            this.logDebug("call retire/dismiss");
            this.logDebug("TID: " + this.Tactical.getEntityByID(_data[0]).m.TwitchID);
            this.logDebug("Name: " + this.Tactical.getEntityByID(_data[0]).m.Name);
			::Const.TwitchInterface.twitchIDToNamePool(this.Tactical.getEntityByID(_data[0]).m.TwitchID,::Const.TwitchInterface.m.TwitchNames.Retired);
			__original(_data);
		}
	});
}