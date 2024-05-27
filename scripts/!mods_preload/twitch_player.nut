::TwitchBrothers.Content.hook_player <- function(){
	::TwitchBrothers.Mod.hook("scripts/entity/tactical/player", function ( q ) {
		q.m.TwitchID <- "";
		q.m.OriginalName <- "";
		q.setStartValuesEx = @(__original) function ( _backgrounds, _addTraits = true ){
			__original(_backgrounds, _addTraits);

			local current_location = this.World.State.getCurrentTown();
			if(current_location != null){ //if null = start of campaign?
				local roster = this.World.getRoster(current_location.getID());
				local bros = roster.getAll();
				local get_new_name = true;
				for (local i = 0; i < 10 && get_new_name; ++i){
					get_new_name = false;
					if(!::Const.TwitchInterface.giveBroNewTwitchName(this)){
						this.logDebug("No Twitchnames!");
						break;					
					}
					foreach (bro in bros){
						if(bro.m.TwitchID == this.m.TwitchID && bro != this){
							this.logDebug("Tried to name '"+this+"' but twitchId was already taken by '"+bro+"' ! Trying for new name.");
							get_new_name = true;
							break;
						}
					}
				}
				if (get_new_name){
					this.logDebug("Resetting bro name to: "+ this.m.OriginalName);
					this.setName(this.m.OriginalName);
				}
			}
		}

		q.setName = @(__original) function (_value){
			if(this.m.TwitchID.len()){
				//free TwitchID
				::Const.TwitchInterface.twitchIDToNamePool(this.m.TwitchID,::Const.TwitchInterface.m.TwitchNames.Pool);
				this.m.TwitchID = "";
			}
			__original(_value);
		}

		q.onHired = @(__original) function (){
			__original();
            this.logDebug("call hire");
			::Const.TwitchInterface.twitchIDToNamePool(this.m.TwitchID,::Const.TwitchInterface.m.TwitchNames.Hired);
		}

		q.onDeath = @(__original) function ( _killer, _skill, _tile, _fatalityType ){
			__original( _killer, _skill, _tile, _fatalityType );
			::Const.TwitchInterface.twitchIDToNamePool(this.m.TwitchID,::Const.TwitchInterface.m.TwitchNames.Dead);
		}
	});
}