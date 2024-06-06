::TwitchBrothers.Content.hook_settlement <- function()
{
	::TwitchBrothers.Mod.hook("scripts/entity/world/settlement", function ( q ) 
	{
		q.updateRoster = @(__original) function ( _force = false )
		{
			__original(_force);

			//update twitchIDs and check for duplicates
			local currentLocation = this.World.State.getCurrentTown();
			if(currentLocation != null)
			{ 
				local roster = this.World.getRoster(currentLocation.getID());
				local bros = roster.getAll();
				//update TwitchIDS
				foreach (bro in bros)
				{
					if(bro.m.TwitchID.len() > 0 && ::Const.TwitchInterface.lookupName(bro.m.TwitchID) != null)
					{
						local info = ::Const.TwitchInterface.lookupName(bro.m.TwitchID);
						bro.setName(info.Name);
						if(bro.m.OriginalTitle.len() == 0)
						{
							bro.setTitle(info.Title);
						}
					}
					else
					{
						if(!::Const.TwitchInterface.giveBroNewTwitchName(bro))
						{
							bro.restoreOriginalName();
						}
					}
				}

				//remove duplicates
				for (local i = 0; i < bros.len(); ++i)
				{
					if(bros[i].m.TwitchID.len() > 0)
					{
						for (local j = i+1; j < bros.len(); ++j)
						{
							if(bros[i].m.TwitchID == bros[j].m.TwitchID)
							{
								bros[j].restoreOriginalName();
							}
						}
					}	
				}
			}
			else
			{
				this.logWarning("Settlement.updateRoster() was called, but no settlement was entered!")
			}
		}
	});
}