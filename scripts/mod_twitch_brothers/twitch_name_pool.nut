this.twitch_name_pool <-{
	m = {
		Data = {}
	}, 

	function updateEntry(_data)
	{
		if(_data.TwitchID in this.m.Data){
			this.m.Data[_data.TwitchID].initWithData(_data);
			return true;
		}else{
			return false;
		}
	}
	function addEntry(_data, _live = true){
		if(!this.updateEntry(_data)){
            this.m.Data[_data.TwitchID] <- this.new("scripts/mod_twitch_brothers/twitch_name_object");
            this.m.Data[_data.TwitchID].initWithData(_data, _live);
        }
	}
	function len(){
		return this.m.Data.len();
	}
	function randValue(){
		return ::MSU.Table.randValue(this.m.Data);
	}
};