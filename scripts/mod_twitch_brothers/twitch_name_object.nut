this.twitch_name_object <- {
	TwitchID = "",
	Name = "",
	Title = "",
	ParentTable = null,
	Live = false,
	
	function create(){

	}

	function initWithData(_data, _live = true){
		this.TwitchID = _data.TwitchID;
		this.Name = _data.Name;
		this.Title = _data.Title;
		this.Live = _live;
		if("Live" in _data)
			this.Live = _data.Live;

	}

	function getName(){
		if(this.Name.len()){
			return this.Name;
		}
		return this.TwitchID;
	}

	function onSerialize(_out)
	{
		//BUG: on '고려견' ?

        this.logDebug("Call serialize name object");
        this.logDebug("TID: " + this.TwitchID);
        this.logDebug("Name: " + this.Name);
		//serialize this.TwitchID
		//::MSU.Utils.serialize(this.TwitchID, _out);
		_out.writeU8(::MSU.Utils.DataType.String);
		_out.writeString(this.TwitchID);
		//serialize this.Name
		//::MSU.Utils.serialize(this.Name, _out);
		_out.writeU8(::MSU.Utils.DataType.String);
		_out.writeString(this.Name);

		//serialize this.Title
		_out.writeU8(::MSU.Utils.DataType.String);
		_out.writeString(this.Title);
	}

	function onDeserialize(_in)
	{ 
        if(::TwitchBrothers.MSU.Serialization.isSavedVersionAtLeast("0.2.1", _in.getMetaData())){
			//deserialize this.TwitchID
			_in.readU8();
			this.TwitchID =_in.readString();
			//deserialize this.Namme
			_in.readU8();
			this.Name =_in.readString();	
			//deserialize this.Title
			_in.readU8();
			this.Title =_in.readString();	
			this.Live = false;
		}else{
			//was v0.2.0
			//deserialize this.TwitchID; change to lowercase to comply with standard of 0.2.1 
			_in.readU8();
			this.TwitchID =_in.readString().tolower();
			//deserialize this.Namme
			_in.readU8();
			this.Name =_in.readString();
			this.Title ="";	
			this.Live = false;
			
		}
	}

};