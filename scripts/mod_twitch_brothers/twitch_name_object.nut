this.twitch_name_object <- {
	m = {
		TwitchID = "",
		Name = "",
		Live = false
	},
	
	function create(){

	}

	function initWithData(_data, _live = true){
		this.m.TwitchID = _data.TwitchID;
		this.m.Name = _data.Name;
		this.m.Live = _live;

	}

	function getName(){
		if(this.m.Name.len()){
			return this.m.Name;
		}
		return this.m.TwitchID;
	}

};