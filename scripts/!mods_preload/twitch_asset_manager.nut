::TwitchBrothers.Content.hook_asset_manager <- function()
{
	::TwitchBrothers.Mod.hook("scripts/states/world/asset_manager", function ( q ) 
	{
		q.setCampaignSettings = @(__original ) function ( _settings )
		{
			__original( _settings );
			local roster = this.World.getPlayerRoster().getAll();
			foreach( bro in roster )
			{
				if(::Const.TwitchInterface.giveBroNewTwitchName( bro ) )
				{
					::Const.TwitchInterface.twitchIDToNamePool( bro.m.TwitchID,::Const.TwitchInterface.m.TwitchNames.Hired );
				}			
			}
		}
	} );
}
