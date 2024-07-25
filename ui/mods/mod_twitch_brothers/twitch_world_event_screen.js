var TwitchEventDecision = function(_buttonRef, _labelRef, _counterRef)
{
    this.button = _buttonRef;
    this.label = _labelRef;
    this.counter = _counterRef;
    this.count = 0;
}

var TwitchEventVotes = function()
{
    //this.mSQHandle = null;

    this.decisions = [];
    this.voterList = {};
    this.voteRunning = false;

    this.timerCount = 0;
    this.timer = null;
    this.timeout = null;

    var self = this;

    var oldFunc1 = WorldEventScreen.prototype.createDIV;
    WorldEventScreen.prototype.createDIV = function (_parentDiv)
    {
        oldFunc1.apply(this,[_parentDiv]);
        self.timer = $('<div class="event-timer text-font-normal font-color-label font-bottom-shadow"></div>');
        this.mContainer.append(self.timer);
    }


    var oldFunc = WorldEventScreen.prototype.renderButtons;
    WorldEventScreen.prototype.renderButtons = function (_data, _hasBigButtons)
    {
        oldFunc.apply(this,[_data, _hasBigButtons]);
        var rows = this.mButtonContainer.children();
        
        self.newEventVote();

        for (var i = 0; i < rows.length; i++) 
        {
            var eventId = $('<div class="event-id text-font-normal font-color-label font-bottom-shadow">' + (i+1) + '</div>');
            var eventCounter = $('<div class="event-counter text-font-normal font-color-label font-bottom-shadow">' + 0 + '</div>');
            
            var currentRow = rows.eq(i);
            currentRow.append(eventId);
            currentRow.append(eventCounter);

            self.decisions[i] = new TwitchEventDecision(currentRow.find('.ui-control').first(), currentRow.find('span'), eventCounter);
        }

        self.timerCount = 10;
        self.timer.text(self.timerCount + 's');
        
        if(self.timeout != null)
            clearTimeout(self.timeout);
        self.timeout = setTimeout(function eventSecond()
        {
            self.timerCount--;
            self.timer.text(self.timerCount + 's');

            if(self.timerCount != 0)
            {
                self.timeout = setTimeout(eventSecond, 1000);
            }else{
                /*trigger event decision*/
                self.stopVote();

                //get most voted decision
                var max = [];
                max.push(self.decisions[0]);
                for (var i = 1; i < self.decisions.length; i++) 
                {
                    if (max[0].count <= self.decisions[i].count) 
                    {
                        if (max[0].count < self.decisions[i].count)
                            max = [];
                        max.push(self.decisions[i]);
                    }
                }

                //select decision //TODO make decisions not interactable
                var selected = Math.floor(Math.random() * max.length);
                
                //show selected decision
                function triggerEvent()
                {
                    max[selected].button.click();
                }

                if(max.length == 1)
                {
                    var i = 0;
                    setTimeout(function blink()
                        {
                            if(i % 2 == 0)
                                max[0].button.addClass('is-selected')
                            else
                                max[0].button.removeClass('is-selected')

                            if(i < 6)
                                setTimeout(blink,300);
                            else
                                setTimeout(triggerEvent,1000);
                            i++;
                        }, 0);
                }
                else
                {
                    var blinkIntervall = 1;
                    var minBlinkCount = 45;
                    var curr = 0;
                    var prev = 0;
                    setTimeout(function blink()
                        {
                            max[prev % max.length].button.removeClass('is-selected');
                            max[curr % max.length].button.addClass('is-selected');
                            if (curr < minBlinkCount || curr % max.length != selected)
                                setTimeout(blink,blinkIntervall * curr);
                            else
                                setTimeout(triggerEvent,1000);
                            prev = curr;
                            curr++;
                        }, 0);
                }
            }    
        },1000);
    }
};

TwitchEventVotes.prototype.voteForEvent = function (_eventId, _value)
{
    if(this.voteRunning && _eventId >= 0 && _eventId <= this.decisions.length)
    {
        this.decisions[_eventId].count += _value;
        this.decisions[_eventId].counter.text(this.decisions[_eventId].count);
        this.updateEventColors();
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
    this.decisions = [];
    this.voterList = {};
    this.voteRunning = true;
}

TwitchEventVotes.prototype.stopVote = function ()
{
    this.voteRunning = false;
}

TwitchEventVotes.prototype.updateEventColors = function ()
{
    var offset = 3;
    var sum = 0;
    for(var i = 0; this.decisions.length > i; i++)
        sum += this.decisions[i].count + offset;
    var avrg = sum/(this.decisions.length-1);

    for(var i = 0; this.decisions.length > i; i++)
    {
        if(this.decisions[i].count + offset < avrg)
        {
            this.decisions[i].label.css("color", interpolateColors("#ff0000", "#dda21f", (this.decisions[i].count + offset) / avrg));
        }else{
            this.decisions[i].label.css("color", interpolateColors("#dda21f", "#00ff00", (this.decisions[i].count + offset - avrg) / (sum - avrg)));
        }
    }
}

registerScreen("TwitchEventVotes", new TwitchEventVotes());