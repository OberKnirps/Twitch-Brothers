"use strict";

var TwitchInterface = function()
{
    this.mSQHandle = null;
    this.twitch_socket = undefined;
    this.twitch_client = null;
}

TwitchInterface.prototype.create = function(_parentDiv)
{
    console.log('TWITCH::CREATE');
    //this.createDIV(_parentDiv);
};

TwitchInterface.prototype.destroy = function ()
{
    console.log('TWITCH::DESTROY');
    if(this.twitch_socket !== undefined){
        this.twitch_socket.close();
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
    this.twitch_socket.send(_data);
}



TwitchInterface.prototype.onConnection = function (_handle)
{
    var TI = this;
    console.log = function(){
        SQ.call(_handle, "logCallback",arguments[0]);
    }

    console.log('TWITCH::CONNECT');
    this.mSQHandle = _handle;
    /*this.twitch_socket = new WebSocket("ws://irc-ws.chat.twitch.tv:80");
    this.twitch_socket.onopen = function(e) {
        SQ.call(TI.mSQHandle, "logCallback","[open] Connection established");
        SQ.call(TI.mSQHandle, "logCallback","Sending to server");
        //TI.twitch_socket.send("My name is John");

        TI.twitch_socket.send('CAP REQ :twitch.tv/tags');
        //TI.twitch_socket.send('CAP REQ :twitch.tv/commands');
        //TI.twitch_socket.send('CAP REQ :twitch.tv/membership');
        TI.twitch_socket.send("PASS 1453218");
        TI.twitch_socket.send("NICK justinfan14042205");
        TI.twitch_socket.send("USER justinfan14042205");
        //TI.twitch_socket.send("JOIN BonjwaChill");
        //TI.twitch_socket.send("PART BonjwaChill");
    };

    this.twitch_socket.onmessage = function(event) {
        //split into single messages
        var messageList = event.data.split("\r\n");

        //split message into parts
        messageList.forEach(function(msg){
            var messageParts = msg.split("( :|:)",2);
            if(messageParts[0].length > 0){
                //TODO parse massage
            }

            //get command
            var commandParts = messageParts[1].split(" ",2);

            //match commands
            //switch (commandParts[1]):


        });



        SQ.call(TI.mSQHandle, "logCallback",'[message] Data received from server: '+ event.data);
        SQ.call(TI.mSQHandle, "messageCallback",'[message]: '+ event.data);
    };*/
        var options = {
          options: {
            debug: false,
            skipUpdatingEmotesets: true
          },
          connection: {
            reconnect: true,
            secure: true
          },
          channels: ["ReismitMais"]
        };
        var c = new client( options );


        c.on( 'message', function( channel, userstate, message, self ) {
            console.log('[message]: '+ message);
        });
        c.connect().then(function(res){console.log(res[0]+"|"+res[1])}, console.log);

        console.log("TWITCH: Connected?");
    
/*
    this.twitch_socket.onclose = function(event) {
        if (event.wasClean) {
            SQ.call(TI.mSQHandle, "logCallback",'[close] Connection closed cleanly, code=${event.code} reason=${event.reason}');
        } else {
            // e.g. server process killed or network down
            // event.code is usually 1006 in this case
            SQ.call(TI.mSQHandle, "logCallback",'[close] Connection died');
        }
    };

    this.twitch_socket.onerror = function(error) {
        SQ.call(TI.mSQHandle, "logCallback",'[error]');
    };*/
/*
    var options = {
        options: {
            debug: true,
            skipUpdatingEmotesets: true
        },
        connection: {
            reconnect: true,
            secure: true
        },
        channels: [ 'ReismitMais' ]
    };
    this.twitch_client = new tmi.Client(options);
    this.twitch_client.on( 'connected', function( address, port ) {
        SQ.call(TI.mSQHandle, "logCallback","TMI: Connected "+address+port);
    });

    this.twitch_client.connect().catch(function(err) {
        SQ.call(TI.mSQHandle, "logCallback", "TMI: Error " + err)
    });

    this.twitch_client.on('message', function(channel, tags, message, self) {
        // "Alca: Hello, World!"
        SQ.call(TI.mSQHandle, "logCallback","".concat(tags['display-name'], ": ").concat(message));
    });
*/
}

registerScreen("TwitchInterface", new TwitchInterface());