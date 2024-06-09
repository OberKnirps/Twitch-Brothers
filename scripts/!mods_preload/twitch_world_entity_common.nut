::TwitchBrothers.Content.override_world_entity_common <- function()
{

	this.Const.World.Common.generateName = function ( _list )
	{
		local nameTemplate = _list[this.Math.rand(0, _list.len() - 1)];
		local twitchName = ::Const.TwitchInterface.getRandomTwitchDisplayName("AsEnemy", [""], 10);
		local vars = [
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomsouthernname",
				this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)]
			],
			[
				"randomknightname",
				this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]
			],
			[
				"randomtown",
				this.Const.World.LocationNames.VillageWestern[this.Math.rand(0, this.Const.World.LocationNames.VillageWestern.len() - 1)]
			]
		];

		if(twitchName != "")
		{
			vars[0][1] = twitchName;
			vars[1][1] = twitchName;
			vars[2][1] = twitchName;

			if(nameTemplate.find("name%") != null)
			{
				nameTemplate = this.buildTextFromTemplate(nameTemplate, vars);
			}

			if(nameTemplate.find("The ") == 0)
			{
				nameTemplate = twitchName + ::MSU.String.replace( nameTemplate, "The ", " the ");
			}
			else if(nameTemplate.find("Sir ") == 0)
			{
				nameTemplate = "Sir " + twitchName;
			}
			else
			{
				nameTemplate = twitchName;
			}
		}	

		return this.buildTextFromTemplate(nameTemplate, vars);
	}
}