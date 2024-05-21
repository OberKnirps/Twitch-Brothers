"use strict";

var TwitchInterface = function()
{
    this.mSQHandle = null;
    this.twitch_client = null;
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
    this.twitch_client = new client( this.options );
        this.twitch_client.on( 'message', function( channel, userstate, message, self ) {
        console.log('[message]: '+ message);
    });
    this.twitch_client.on( 'ping', function() {
        console.log('[ping]');
    });
    this.twitch_client.on( 'pong', function( latency ) {
        console.log('[pong]: '+ latency);
    });
    this.twitch_client.connect().then(function(res){console.log(res[0]+"|"+res[1])}, console.log);
}

TwitchInterface.prototype.updateChannels = function (_channels)
{
    this.options.channels = _channels.split(/ ,|, |,/);
}

TwitchInterface.prototype.onConnection = function (_handle)
{

    console.log = function(){
        SQ.call(_handle, "logCallback",arguments[0]);
    }

    console.log('TWITCH::CONNECT');
    this.mSQHandle = _handle;
    //this.initTwitchClient();
    
}

registerScreen("TwitchInterface", new TwitchInterface());