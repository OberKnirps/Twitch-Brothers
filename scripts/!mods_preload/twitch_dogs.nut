::TwitchBrothers.Content.hook_dogs <- function(){
	::TwitchBrothers.Mod.hook("scripts/items/accessory/wolf_item", function ( q ) {
		q.create = @(__original) function () 
		{
			__original();
			local name = ::Const.TwitchInterface.getRandomTwitchDisplayName("AsDog", this.Const.Strings.WardogNames);
			if(name != null)
			{
				this.setName(name + " the Wolf");
			}
		}
	});

	::TwitchBrothers.Mod.hook("scripts/items/accessory/warhound_item", function ( q ) {
		q.create = @(__original) function () 
		{
			__original();
			local name = ::Const.TwitchInterface.getRandomTwitchDisplayName("AsDog", this.Const.Strings.WardogNames);
			if(name != null)
			{
				this.setName(name + " the Warhound");
			}
		}
	});

	::TwitchBrothers.Mod.hook("scripts/items/accessory/wardog_item", function ( q ) {
		q.create = @(__original) function () 
		{
			__original();
			local name = ::Const.TwitchInterface.getRandomTwitchDisplayName("AsDog", this.Const.Strings.WardogNames);
			if(name != null)
			{
				this.setName(name + " the Wardog");
			}
		}
	});
}