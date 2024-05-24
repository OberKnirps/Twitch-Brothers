"use strict";

var TwitchInterface = function()
{
    this.mSQHandle = null;
    this.twitch_client = null;
    this.TwitchNames = [];
    this.IgnoreNames =[];
    this.BlackList =[];
    this.options = {
      options: {
        debug: false,
        skipUpdatingEmotesets: true
      },
      connection: {
        reconnect: true,
        secure: true
      },
      channels: []
    };
}

TwitchInterface.prototype.create = function(_parentDiv)
{
    console.log('TWITCH::CREATE');
    //this.createDIV(_parentDiv);
};

TwitchInterface.prototype.destroy = function ()
{
    console.log('TWITCH::DESTROY');
    if(this.twitch_client !== undefined){
        this.twitch_client.disconnect();
    }

    //this.destroyDIV();
}

TwitchInterface.prototype.register = function (_parentDiv)
{
    console.log('TWITCH::REGISTER');
    this.create(_parentDiv);
}

TwitchInterface.prototype.unregister = function ()
{
    console.log('TWITCH::UNREGISTER');
    this.destroy();
}

TwitchInterface.prototype.sendMSG = function (_data)
{
    //this.twitch_socket.send(_data);
}

TwitchInterface.prototype.initTwitchClient = function ()
{
    SQ.call(this.mSQHandle, "updateChannels", null);
    var thisTI = this;
    this.twitch_client = new client( this.options );
        this.twitch_client.on( 'message', function( channel, userstate, message, self ) {
            if(!thisTI.TwitchNames.includes(userstate["display-name"]) && !thisTI.IgnoreNames.includes(userstate["display-name"])){
                for(var i = 0; i < thisTI.BlackList.length; i++){ 
                    if(userstate["display-name"].includes(thisTI.BlackList[i])) {
                        thisTI.IgnoreNames.push(userstate["display-name"]);
                        return;
                    }
                }
                thisTI.TwitchNames.push(userstate["display-name"]);
                SQ.call(thisTI.mSQHandle, "namesDirtyCallback",null);
            }
        }
    );

    this.twitch_client.connect().then(function(res){console.log(res[0]+"|"+res[1])}, console.log);
}

TwitchInterface.prototype.transferNames = function (_TwitchNames)
{
    SQ.call(this.mSQHandle, "transferNamesCallback",this.TwitchNames);
}


TwitchInterface.prototype.updateChannels = function (_channels)
{
    this.options.channels = _channels.split(/[ ,;]+/);
}

TwitchInterface.prototype.updateBlacklist = function(_names)
{
    var thisTI = this;
    thisTI.BlackList = [];
    _names.split(/[ ,;]+/).forEach(function(_exp){thisTI.BlackList.push(new RegExp(_exp,"i"))});
}

TwitchInterface.prototype.onConnection = function (_handle)
{

    /*console.log = function(){
        SQ.call(_handle, "logCallback",arguments[0]);
    }*/

    console.log('TWITCH::CONNECT');
    this.mSQHandle = _handle;
    //this.initTwitchClient();
    
}

registerScreen("TwitchInterface", new TwitchInterface());