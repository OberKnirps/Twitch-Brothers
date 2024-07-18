var TwitchEventVotes = function()
{
    //this.mSQHandle = null;

    this.voteCounterRefs = [];
    this.voteCounts = [];
    this.voterList = {};
};

TwitchEventVotes.prototype.voteForEvent = function (_eventId, _value)
{
    if(_eventId <= this.voteCounterRefs.length)
    {
        this.voteCounts[_eventId] += _value;
        this.voteCounterRefs[_eventId].text(this.voteCounts[_eventId]);
    }
}

TwitchEventVotes.prototype.uniqueVoteForEvent = function (_uid, _eventId)
{
    if(this.voterList.hasOwnProperty(_uid))
    {
        this.voteForEvent(this.voterList[_uid], -1);    
    }

    this.voterList[_uid] = _eventId;    
    this.voteForEvent(_eventId, 1);    
}

TwitchEventVotes.prototype.newEventVote = function ()
{
    this.voteCounterRefs = [];
    this.voteCounts = [];
    this.voterList = [];
}

TwitchEventVotes.prototype.addVoteOption = function (_eventId, _eventCounterRef)
{
    this.voteCounterRefs[_eventId] = _eventCounterRef;
    this.voteCounts[_eventId] = 0;
}

registerScreen("TwitchEventVotes", new TwitchEventVotes());


var oldFunc = WorldEventScreen.prototype.renderButtons;
WorldEventScreen.prototype.renderButtons = function (_data, _hasBigButtons)
{
	oldFunc.apply(this,[_data, _hasBigButtons]);
    var rows = this.mButtonContainer.children();
    
    Screens["TwitchEventVotes"].newEventVote();

    for (var i = 0; i < rows.length; i++) 
    {
        var eventId = $('<div class="event-id text-font-normal font-color-label font-bottom-shadow">' + (i+1) + '</div>');
        var eventCounter = $('<div class="event-counter text-font-normal font-color-label font-bottom-shadow">' + 0 + '</div>');
        
        var currentRow = rows.eq(i);
        currentRow.append(eventId);
        currentRow.append(eventCounter);

        Screens["TwitchEventVotes"].addVoteOption(i+1,eventCounter);
    }
}