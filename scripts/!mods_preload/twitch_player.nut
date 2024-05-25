::TwitchBrothers.Content.hookPlayer <- function(){
	::TwitchBrothers.Mod.hook("scripts/entity/tactical/player", function ( q ) {
		q.m.TwitchID <- "";
		q.m.OriginalName <- "";
		q.setStartValuesEx = @(__original) function ( _backgrounds, _addTraits = true ){
			__original(_backgrounds, _addTraits);
			if(::Const.TwitchInterface.m.TwitchNames.Pool.len()){
				this.m.OriginalName = this.m.Name;
				local elem = ::Const.TwitchInterface.m.TwitchNames.Pool.randValue();
				this.m.TwitchID = elem.m.TwitchID;
				this.m.Name = elem.getName();
			}
		}
	});

	/*::TwitchBrothers.Mod.hookTree("scripts/entity/tactical/actor", function ( q ) {
		q.create = @(__original) function (){
			__original();
			this.logDebug("Type: "+q.m.Type);
			this.logDebug("OldName: "+q.m.Name);
			if(::Const.TwitchInterface.m.TwitchNames.List.len()){
				q.m.Name = ::Const.TwitchInterface.m.TwitchNames.List[this.Math.rand(0, ::Const.TwitchInterface.m.TwitchNames.List.len() - 1)];
			}else{
				q.m.Name = "Twitch Actor";
			}
			this.logDebug("newName: "+q.m.Name);

		}
	});*/
}