::TwitchBrothers.Content.hook_items <- function()
{
	::TwitchBrothers.Mod.hookTree("scripts/items/item", function ( q ) 
	{
		if(q.contains("getRandomCharacterName",true))
		{	
			q.getRandomCharacterName = @(__original) function (_list) 
			{
				local vars = 
					[
						[
							"randomname",
							::Const.TwitchInterface.getRandomTwitchDisplayName("AsItem", this.Const.Strings.CharacterNames, 10)
						],
						[
							"randomsouthernname",
							::Const.TwitchInterface.getRandomTwitchDisplayName("AsItem", this.Const.Strings.SouthernNames, 10)
						],
						[
							"randomtown",
							this.Const.World.LocationNames.VillageWestern[this.Math.rand(0, this.Const.World.LocationNames.VillageWestern.len() - 1)]
						]
					];
				switch (_list)
				{
					case this.Const.Strings.BanditLeaderNames:
						return this.buildTextFromTemplate(_list[this.Math.rand(0, _list.len() - 1)], vars);
						break;

					case this.Const.Strings.KnightNames:
						return "Sir " + vars[0][1];
						break;

					case this.Const.Strings.NomadChampionStandalone:
						return vars[1][1] + " " + this.Const.Strings.NomadChampionTitles[this.Math.rand(0, this.Const.Strings.NomadChampionTitles.len() - 1)];
						break;

					default:
						return __original(_list);
				}
			}
		}
		
	});
}