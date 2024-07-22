"use strict";

var TwitchInterface = function()
{
    this.mSQHandle = null;
    this.TwitchClient = null;
    this.TwitchNames = {};
    this.IgnoreIDs =[];
    this.BlackList =[];
    this.Settings = {};
    this.Options = 
    {
      options: 
      {
        debug: false,
        skipUpdatingEmotesets: true
      },
      connection: 
      {
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
    if(this.TwitchClient !== undefined)
    {
        this.TwitchClient.disconnect();
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
    if(this.TwitchClient != null)
    {
        this.TwitchClient.disconnect().then(function(res){console.log(res[0]+"|"+res[1])}, console.log);
    }
    this.TwitchClient = new client( this.Options );
    this.TwitchClient.on( 'message', function( channel, userstate, message, self ) 
    {
        if(!thisTI.TwitchNames.hasOwnProperty(userstate["username"]) && !thisTI.IgnoreIDs.includes(userstate["username"]))
        {
            for(var i = 0; i < thisTI.BlackList.length; i++)
            { 
                if(userstate["username"].includes(thisTI.BlackList[i])) 
                {
                    thisTI.IgnoreIDs.push(userstate["username"]);
                    return;
                }
            }
            thisTI.TwitchNames[userstate["username"]] = {"TwitchID":userstate["username"], "DisplayName": userstate["display-name"], "Name": userstate["display-name"], "Title": ""};
            SQ.call(thisTI.mSQHandle, "addTwitchName",thisTI.TwitchNames[userstate["username"]]);
        }

        /*testcode
        message = " !bbname UltraKnirps !bbtitle the.Author";
        SQ.call(thisTI.mSQHandle, "logCallback","Name: "+ userstate["username"]);
        */

        var characterFilter = "";
        if(thisTI.Settings.Filter)
            characterFilter = /[|&;$%@<>(),.:\+\{\}\[\]\\\/]+/g;

        if(userstate["badges-raw"] == null)
            userstate["badges-raw"] = "";

        //process commands
        var commandList = message.split(/ (?=!)/g);
        commandList.forEach( function(_str)
        {
            if(typeof _str != "string")
            {
                return;
            }

            if(_str.includes("!"+thisTI.Settings.Commands.Name.String)
                && thisTI.Settings.Commands.Name.Enabled
                && userstate["badges-raw"].includes(new RegExp(thisTI.Settings.Commands.Name.Role,"")))
            {
                var commandBody = "";
                //if _str === "!<command name>" reset name (update with empty name)
                if(_str !== "!"+thisTI.Settings.Commands.Name.String)
                {
                    commandBody = _str.split("!"+thisTI.Settings.Commands.Name.String+" ")[1];

                    //filter some special/controll characters, just to be safe
                    commandBody = commandBody.replace(characterFilter, "");
    
                    //check custom name for blacklist
                    for(var i = 0; i < thisTI.BlackList.length; i++)
                    { 
                        if(commandBody.includes(thisTI.BlackList[i])) 
                        {
                            return;
                        }
                    }
                }

                thisTI.TwitchNames[userstate["username"]].Name = commandBody;
                SQ.call(thisTI.mSQHandle, "updateTwitchName",thisTI.TwitchNames[userstate["username"]]);
            }
            else if(_str.includes("!"+thisTI.Settings.Commands.Title.String+" ")
                && thisTI.Settings.Commands.Title.Enabled
                && userstate["badges-raw"].includes(new RegExp(thisTI.Settings.Commands.Title.Role,"")))
            {
                var commandBody = "";
                //if _str == "!<command name>" reset title (update with empty title)
                if(_str !== "!"+thisTI.Settings.Commands.Title.String)
                {
                    commandBody = _str.split("!"+thisTI.Settings.Commands.Title.String+" ")[1];

                    //filter some special/controll characters, just to be safe
                    commandBody = commandBody.replace(characterFilter, "");
    
                    //check custom title for blacklist
                    for(var i = 0; i < thisTI.BlackList.length; i++)
                    { 
                        if(commandBody.includes(thisTI.BlackList[i])) 
                        {
                            return;
                        }
                    }
                }

                thisTI.TwitchNames[userstate["username"]].Title = commandBody;
                SQ.call(thisTI.mSQHandle, "updateTwitchName",thisTI.TwitchNames[userstate["username"]]);
            }
            else if(_str.includes("!"+thisTI.Settings.Commands.Clear.String+" ")
                && thisTI.Settings.Commands.Clear.Enabled
                && userstate["badges-raw"].includes(new RegExp(thisTI.Settings.Commands.Clear.Role,"")))
            {
                var commandBody = _str.split("!"+thisTI.Settings.Commands.Clear.String+" ")[1];
                commandBody = commandBody.replace(/[ @]+/g,"");
                if(commandBody.toLowerCase() in thisTI.TwitchNames)
                {
                    thisTI.TwitchNames[commandBody.toLowerCase()].Name = commandBody;
                    thisTI.TwitchNames[commandBody.toLowerCase()].Title = "";    
                    SQ.call(thisTI.mSQHandle, "updateTwitchName",thisTI.TwitchNames[commandBody.toLowerCase()]);   
                }
            }
            else if(_str.includes("!"+thisTI.Settings.Commands.Block.String+" ")
                && thisTI.Settings.Commands.Block.Enabled
                && userstate["badges-raw"].includes(new RegExp(thisTI.Settings.Commands.Block.Role,"")))
            {
                var commandBody = _str.split("!"+thisTI.Settings.Commands.Block.String+" ")[1].toLowerCase();
                commandBody = commandBody.replace(/[ @]+/g,"");
                if(commandBody in thisTI.TwitchNames)
                {
                    thisTI.IgnoreIDs.push(commandBody);
                    delete thisTI.TwitchNames[commandBody];
                    SQ.call(thisTI.mSQHandle, "banTwitchID",commandBody);  
                }
            }
        });

        //count votes
        if(/^\d+(?=\W{0,3}$)/.test(message))
        {
            Screens["TwitchEventVotes"].uniqueVoteForEvent(userstate["username"], parseInt(message)-1);
        }        
    });

    this.TwitchClient.on( 'ban', function( channel, username, reason ) 
    {
        if(thisTI.Settings.AutoBan)
        {
            thisTI.IgnoreIDs.push(username);
            delete thisTI.TwitchNames[username];
            SQ.call(thisTI.mSQHandle, "banTwitchID",username);
        }
    });

    this.TwitchClient.connect().then(function(res){console.log(res[0]+"|"+res[1])}, console.log);
}

TwitchInterface.prototype.transferNames = function (_TwitchNames)
{
    SQ.call(this.mSQHandle, "transferNamesCallback",this.TwitchNames);
}


TwitchInterface.prototype.updateChannels = function (_channels)
{
    this.Options.channels = _channels.split(/[ ,;]+/);
}

TwitchInterface.prototype.updateBlacklist = function(_names)
{
    var thisTI = this;

    for(var i = 0; i < thisTI.BlackList.length; i++)
    {
        for(var name in thisTI.TwitchNames)
        {
            if(name.includes(thisTI.BlackList[i])) 
            {
                delete thisTI.TwitchNames[name];
                return;
            }
        } 
    }

    thisTI.BlackList = [];
    thisTI.IgnoreIDs = [];
    _names.split(/[ ,;]+/).forEach(function(_exp){thisTI.BlackList.push(new RegExp(_exp,"i"))});
}

TwitchInterface.prototype.updateSettings = function(_settings)
{
    this.Settings = _settings;
}

TwitchInterface.prototype.onConnection = function (_handle)
{

   

    console.log('TWITCH::CONNECT');
    this.mSQHandle = _handle;
    //this.initTwitchClient();
     /*console.log = function(){
        SQ.call(this.mSQHandle , "logCallback","text");
    }*/
}

registerScreen("TwitchInterface", new TwitchInterface());