::TwitchBrothers.Content.hookPlayer <- function(){
	::TwitchBrothers.Mod.hook("scripts/entity/tactical/player", function ( q ) {
		q.setStartValuesEx = @(__original) function ( _backgrounds, _addTraits = true ){
			if(::Const.TwitchInterface.m.TwitchNames.dirty){
				::Const.TwitchInterface.transferNames();
			}

			if(::Const.TwitchInterface.m.TwitchNames.List.len())
				q.m.Name = ::Const.TwitchInterface.m.TwitchNames.List[this.Math.rand(0, ::Const.TwitchInterface.m.TwitchNames.List.len() - 1)];
			return __original(_backgrounds, _addTraits);
		}
	});
}