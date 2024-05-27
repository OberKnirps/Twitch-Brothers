::TwitchBrothers.Content.hook_world_state <- function(){
	::TwitchBrothers.Mod.hook("scripts/states/world_state", function ( q ) {
		q.onSerialize = @(__original) function (_out){
			::Const.TwitchInterface.onSerialize(_out);
			__original(_out);
		}
		q.onDeserialize = @(__original) function (_in){
			__original(_in);
			if (::TwitchBrothers.MSU.Serialization.isSavedVersionAtLeast("0.2.0", _in.getMetaData())) {
				::Const.TwitchInterface.onDeserialize(_in);
			}
		}		
		local flushSavegameNamePools = function (){
	        foreach (name in ::Const.TwitchInterface.m.TwitchNames.Hired.m.Data){
	            if(name.Live){
	                ::Const.TwitchInterface.nameToNamePool(name,::Const.TwitchInterface.m.TwitchNames.Pool);
	            }else{
	            	::Const.TwitchInterface.m.TwitchNames.Hired.deleteEntry(name.TwitchID);
	            }
	        }
	        
	        foreach (name in ::Const.TwitchInterface.m.TwitchNames.Dead.m.Data){
	            if(name.Live){
	                ::Const.TwitchInterface.nameToNamePool(name,::Const.TwitchInterface.m.TwitchNames.Pool);
	            }else{
	            	::Const.TwitchInterface.m.TwitchNames.Dead.deleteEntry(name.TwitchID);
	            }
	        }

	        foreach (name in ::Const.TwitchInterface.m.TwitchNames.Retired.m.Data){
	            if(name.Live){
	                ::Const.TwitchInterface.nameToNamePool(name,::Const.TwitchInterface.m.TwitchNames.Pool);
	            }else{
	            	::Const.TwitchInterface.m.TwitchNames.Retired.deleteEntry(name.TwitchID);
	            }
	        }
        	::Const.TwitchInterface.updateNameCounter();
		}

		q.loadCampaign = @(__original) function ( _campaignFileName ){
			//flush pools before load, because they will probably be filled on load
			flushSavegameNamePools();
			__original(_campaignFileName);
		}
		q.exitGame = @(__original) function (){
			__original();	
			//flush pools after exit game, because ironman could proc an autosave
			flushSavegameNamePools();
		}

	});
}