::mods_hookClass("entity/tactical/player", function ( o ) {
	local oldFunc = o.setStartValuesEx;
	o.setStartValuesEx = function ( _backgrounds, _addTraits = true ){
		if(::Const.TwitchInterface.m.TwitchNames.dirty){
			::Const.TwitchInterface.transferNames();
		}

		this.m.Name = ::Const.TwitchInterface.m.TwitchNames.List[this.Math.rand(0, ::Const.TwitchInterface.m.TwitchNames.List.len() - 1)];
		local res = oldFunc(_backgrounds, _addTraits);
		return res;
	}
});