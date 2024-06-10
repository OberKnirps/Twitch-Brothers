::TwitchBrothers.Content.hook_actor <- function()
{
	::TwitchBrothers.Mod.hookTree("scripts/entity/tactical/actor", function ( q ) 
	{
		q.create = @(__original) function ()
		{
			__original();

			local name;
			local title;
			local troopInfo;
			local twitchName = ::Const.TwitchInterface.getRandomTwitchDisplayName("AsEnemy", [""], 10);

			if(this.m.Type == -1 || twitchName == "") return;

			foreach (troop in this.Const.World.Spawn.Troops)
			{
				if(troop.ID == this.m.Type)
				{
					troopInfo = troop;
					break;
				}
			}

			if("TitleList" in troopInfo && troopInfo.TitleList != null)
			{
				title = " " + troopInfo.TitleList[this.Math.rand(0, troopInfo.TitleList.len() - 1)];
			}
			else
			{
				title = " the " + this.Const.Strings.EntityName[this.m.Type];
			}

			if("NameList" in troopInfo && troopInfo.NameList != null && title != "")
			{
				name = troopInfo.NameList[this.Math.rand(0, troopInfo.NameList.len() - 1)];
				if(name.find("name%") != null)
				{
					local vars = 
						[
							[
								"randomname",
								twitchName
							],
							[
								"randomsouthernname",
								twitchName
							],
							[
								"randomtown",
								"REPORT THIS AS BUG"
							]
						];
					name = this.buildTextFromTemplate(name, vars);
				}
				else
				{
					if(name.find("The ") == 0)
					{
						name = twitchName + ::MSU.String.replace( name, "The ", " the ");
					}
					else if(name.find("Sir ") == 0)
					{
						name = "Sir " + twitchName;
					}
					else
					{
						name = twitchName + title;
					}
				}
				this.setName(name);
			}
		}
	});
}