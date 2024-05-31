"use strict";

var TwitchInterface = function()
{
    this.mSQHandle = null;
    this.twitch_client = null;
    this.TwitchNames = {};
    this.IgnoreIDs =[];
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
    if(this.twitch_client != null){
        this.twitch_client.disconnect().then(function(res){console.log(res[0]+"|"+res[1])}, console.log);
    }
    this.twitch_client = new client( this.options );
    this.twitch_client.on( 'message', function( channel, userstate, message, self ) {
        if(!thisTI.TwitchNames.hasOwnProperty(userstate["username"]) && !thisTI.IgnoreIDs.includes(userstate["username"])){
            for(var i = 0; i < thisTI.BlackList.length; i++){ 
                if(userstate["username"].includes(thisTI.BlackList[i])) {
                    thisTI.IgnoreIDs.push(userstate["username"]);
                    return;
                }
            }
            thisTI.TwitchNames[userstate["username"]] = {"TwitchID":userstate["username"], "Name": userstate["display-name"], "Title": ""};
            SQ.call(thisTI.mSQHandle, "addTwitchName",thisTI.TwitchNames[userstate["username"]]);
        }

        /*testcode
        message = " !bbname UltraKnirps !bbtitle the.Author";
        SQ.call(thisTI.mSQHandle, "logCallback","Name: "+ userstate["username"]);
        */

        //commands
        var commandList = message.split(/ (?=!)/g);
        commandList.forEach( function(_str){
            if(typeof _str != "string"){
                return;
            }

            if(_str.includes("!bbname ")){ //TODO make customisable in settings
                var commandBody = _str.split("!bbname ")[1];
                //filter some special/controll characters, just to be safe
                commandBody = commandBody.replace(/[|&;$%@"'<>()+,.:{}\[\]]/g, "");

                //check custom name for blacklist
                for(var i = 0; i < thisTI.BlackList.length; i++){ 
                    if(commandBody.includes(thisTI.BlackList[i])) {
                        return;
                    }
                }
                thisTI.TwitchNames[userstate["username"]].Name = commandBody;
                SQ.call(thisTI.mSQHandle, "updateTwitchName",thisTI.TwitchNames[userstate["username"]]);
                return;

            }else if(_str.includes("!bbtitle ")){
                var commandBody = _str.split(/!bbtitle /)[1];
                //filter some special/controll characters, just to be safe
                commandBody = commandBody.replace(/[|&;$%@"'<>()+,.:{}\[\]]/g, "");


                thisTI.TwitchNames[userstate["username"]].Title = commandBody;
                SQ.call(thisTI.mSQHandle, "updateTwitchName",thisTI.TwitchNames[userstate["username"]]);


            }else if(_str.includes("!bbclear ") && userstate["badges-raw"].includes(/broadcaster|moderator/)){
                var commandBody = _str.split(/!bbclear +@*| /)[1].toLowerCase();
                thisTI.TwitchNames[commandBody].Name = commandBody;
                thisTI.TwitchNames[commandBody].Title = "";
                SQ.call(thisTI.mSQHandle, "updateTwitchName",thisTI.TwitchNames[commandBody]);


            }else if(_str.includes("!bbblock ") && userstate["badges-raw"].includes(/broadcaster|moderator/)){
                var commandBody = _str.split(/!bbblock +@*| /)[1].toLowerCase();
                thisTI.IgnoreIDs.push(commandBody);
                delete thisTI.TwitchNames[commandBody];
                SQ.call(thisTI.mSQHandle, "deleteTwitchName",commandBody);

            }
        })
        
    });

    this.twitch_client.on( 'ban', function( channel, username, reason ) {
        thisTI.IgnoreIDs.push(username);
        delete thisTI.TwitchNames[username];
        SQ.call(thisTI.mSQHandle, "deleteTwitchName",username);
    });

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