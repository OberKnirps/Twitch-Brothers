::TwitchBrothers.Content.hook_dogs <- function(){
	::TwitchBrothers.Mod.hook("scripts/items/accessory/wolf_item", function ( q ) {
		q.create = @(__original) function () 
		{
			__original();
			local name = ::Const.TwitchInterface.getRandomTwitchName("AsDog");
			if(name != null)
			{
				this.setName(name.Name);
			}
		}
	});

	::TwitchBrothers.Mod.hook("scripts/items/accessory/warhound_item", function ( q ) {
		q.create = @(__original) function () 
		{
			__original();
			local name = ::Const.TwitchInterface.getRandomTwitchName("AsDog");
			if(name != null)
			{
				this.setName(name.Name);
			}
		}
	});

	::TwitchBrothers.Mod.hook("scripts/items/accessory/wardog_item", function ( q ) {
		q.create = @(__original) function () 
		{
			__original();
			local name = ::Const.TwitchInterface.getRandomTwitchName("AsDog");
			if(name != null)
			{
				this.setName(name.Name);
			}
		}
	});
}