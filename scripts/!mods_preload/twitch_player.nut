::TwitchBrothers.Content.hook_player <- function()
{
	::TwitchBrothers.Mod.hook("scripts/entity/tactical/player", function ( q ) 
	{
		q.m.TwitchID <- "";
		q.m.OriginalName <- "";
		q.m.OriginalTitle <- "";

		q.restoreOriginalName <- function()
		{
			if(this.m.OriginalName.len() > 0)
				this.setName(this.m.OriginalName);
			if(this.m.OriginalTitle.len() > 0)
				this.setTitle(this.m.OriginalTitle);
			this.m.TwitchID = "";
		}

		q.getRosterTooltip = @(__original) function ()
		{
			local tooltip = __original();
			if(this.m.TwitchID.len() > 0)
			{
				tooltip.push({
					id = tooltip[tooltip.len()-1].id+1,
					type = "text",
					text = "Twitch ID: " + this.m.TwitchID
				});
			}
			return tooltip;
		}

		q.onHired = @(__original) function ()
		{
			__original();
			::Const.TwitchInterface.twitchIDToNamePool(this.m.TwitchID,::Const.TwitchInterface.m.TwitchNames.Hired);
		}

		q.onDeath = @(__original) function ( _killer, _skill, _tile, _fatalityType )
		{
			__original( _killer, _skill, _tile, _fatalityType );
			::Const.TwitchInterface.twitchIDToNamePool(this.m.TwitchID,::Const.TwitchInterface.m.TwitchNames.Dead);
		}

		q.onSerialize = @(__original) function (_out)
		{
			__original(_out);
			_out.writeString(this.m.TwitchID);
			_out.writeString(this.m.OriginalName);
			_out.writeString(this.m.OriginalTitle);			
		}
		
		q.onDeserialize = @(__original) function (_in)
		{
			__original(_in);
        	if(::TwitchBrothers.MSU.Serialization.isSavedVersionAtLeast("0.2.2", _in.getMetaData()))
        	{
				this.m.TwitchID =_in.readString();
				this.m.OriginalName =_in.readString();
				this.m.OriginalTitle =_in.readString();
        	}
		}
	});
}