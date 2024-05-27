this.twitch_name_object <- {
	TwitchID = "",
	Name = "",
	ParentTable = null,
	Live = false,
	
	function create(){

	}

	function initWithData(_data, _live = true){
		this.TwitchID = _data.TwitchID;
		this.Name = _data.Name;
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
	}

	function onDeserialize(_in)
	{ 
		//deserialize this.Name
		//this.TwitchID = ::MSU.Utils.deserialize(_in);
		_in.readU8();
		this.TwitchID =_in.readString();
		//deserialize this.TwitchID
		//this.Name = ::MSU.Utils.deserialize(_in);
		_in.readU8();
		this.Name =_in.readString();	
		this.Live = false;
	}

};