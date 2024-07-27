"use strict";

var TwitchEventDecision = function(_buttonRef, _labelRef, _counterRef)
{
    this.button = _buttonRef;
    this.label = _labelRef;
    this.counter = _counterRef;
    this.count = 0;
}

var TwitchEventVotes = function()
{
    this.mSQHandle = null;

    this.decisions = [];
    this.voterList = {};
    this.voteRunning = false;
    this.gotFirstVote = false;

    this.timerCount = 0;
    this.timer = null;
    this.timeout = null;
    this.startTime = null;

    this.settings = 
    {
        active: true,
        timer:
        {
            active: true,
            waitForVote: true,
            duration: 5, //in sec
            selection: 
            {
                manual: false,
                auto: true,
                duration: 1, //in sec
                speed: 10, //1-100
                delay: 2, //in sec
            },
            randomizeChoice:
            {
                active: true,
                duration: 1, //in sec
                speed: 10 //1-100
            }        
        },
        color:
        {
            active: true,
            colorGood: '#00ff00',
            colorBad: '#ff0000',
            voteOffset: 2
        }
    }

    var self = this;

    var oldFunc1 = WorldEventScreen.prototype.createDIV;
    WorldEventScreen.prototype.createDIV = function (_parentDiv)
    {
        oldFunc1.apply(this,[_parentDiv]);
        self.timer = $('<div class="event-timer text-font-normal font-color-label font-bottom-shadow"></div>');
        this.mContainer.append(self.timer);
    }

    var oldFunc2 = WorldEventScreen.prototype.hide;
    WorldEventScreen.prototype.hide = function (_eventData, _withSlideAnimation)
    {
        clearTimeout(self.timeout); //make sure events aren't triggered after a decision is manually selected
        oldFunc2.apply(this,[_eventData, _withSlideAnimation]);
    }

    var oldFunc = WorldEventScreen.prototype.renderButtons;
    WorldEventScreen.prototype.renderButtons = function (_data, _hasBigButtons)
    {
        clearTimeout(self.timeout); //make sure events aren't triggered after a decision is manually selected
        oldFunc.apply(this,[_data, _hasBigButtons]);
        if(!self.settings.active) return;

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

        self.timer.text('');
        if(self.settings.timer.active)
        {
            var buttonContainerRef = this.mButtonContainer;

            if(!self.settings.timer.selection.manual)
            {
                this.mButtonContainer.append($('<div class="blocker"></div>'));
            }

            self.timerCount = self.settings.timer.duration;
            self.timer.text(self.timerCount + 's');
            
            if(self.timeout != null)
                clearTimeout(self.timeout);
            self.timeout = setTimeout(function eventSecond()
            {
                if(!self.gotFirstVote && self.settings.timer.waitForVote)
                {
                    self.timeout = setTimeout(eventSecond, 1000);
                    return;
                }
                self.timerCount--;
                self.timer.text(self.timerCount + 's');

                if(self.timerCount != 0)
                {
                    self.timeout = setTimeout(eventSecond, 1000);
                }
                else
                {
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

                    //select decision
                    var selected = Math.floor(Math.random() * max.length);
                    
                    //show selected decision
                    var triggerEvent = function ()
                    {
                        if(self.settings.timer.selection.auto)
                            max[selected].button.click();
                    }
                    var selectionBlink = (function ()
                        {
                            var i = 0; //static because of self-invoking function
                            return function ()
                            {
                                if(i % 2 == 0)
                                    max[selected].button.addClass('is-selected')
                                else
                                    max[selected].button.removeClass('is-selected')

                                if(Date.now() - self.startTime.getTime() < self.settings.timer.selection.duration * 1000
                                    || i % 2 == 1)
                                {    
                                    setTimeout(selectionBlink, 600/self.settings.timer.selection.speed);
                                }else{
                                    buttonContainerRef.append($('<div class="blocker"></div>'));
                                    setTimeout(triggerEvent, self.settings.timer.selection.delay * 1000);
                                }
                                i++;
                            }
                        })();

                    var blink = (function () 
                        {
                            var blinkIntervall = 100/self.settings.timer.randomizeChoice.speed;
                            var curr = 0;
                            var prev = 0;

                            return function ()
                            {
                                max[prev % max.length].button.removeClass('is-selected');
                                max[curr % max.length].button.addClass('is-selected');
                                if (Date.now() - self.startTime.getTime() < self.settings.timer.randomizeChoice.duration * 1000 || curr % max.length != selected)
                                {
                                    setTimeout(blink,blinkIntervall * curr);
                                }else{
                                    self.startTime = new Date();
                                    setTimeout(selectionBlink, 0);
                                }
                                prev = curr;
                                curr++;  
                            }
                        })();

                    self.startTime = new Date();
                    if(max.length == 1 || !self.settings.timer.randomizeChoice.active)
                    {
                        setTimeout(selectionBlink, 0);
                    }
                    else
                    {
                        setTimeout(blink, 0);
                    }
                }    
            },1000);
        }
    }
};

TwitchEventVotes.prototype.onConnection = function (_handle)
{
    this.mSQHandle = _handle;
}

TwitchEventVotes.prototype.updateSettings = function(_settings)
{
    this.settings = _settings;
}

TwitchEventVotes.prototype.voteForEvent = function (_eventId, _value)
{
    if(this.voteRunning && _eventId >= 0 && _eventId <= this.decisions.length)
    {
        this.decisions[_eventId].count += _value;
        this.decisions[_eventId].counter.text(this.decisions[_eventId].count);
        this.updateEventColors();
        this.gotFirstVote = true;
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
    this.gotFirstVote = false;
}

TwitchEventVotes.prototype.stopVote = function ()
{
    this.voteRunning = false;
    this.gotFirstVote = false;
}

TwitchEventVotes.prototype.updateEventColors = function ()
{
    if (!this.settings.color.active) 
        return;
    var offset = this.settings.color.voteOffset;
    var sum = 0;
    for(var i = 0; this.decisions.length > i; i++)
        sum += this.decisions[i].count + offset;
    var avrg = sum/this.decisions.length;

    for(var i = 0; this.decisions.length > i; i++)
    {
        if(this.decisions[i].count + offset < avrg)
        {
            this.decisions[i].label.css("color", interpolateColors(this.settings.color.colorBad, "#dda21f", (this.decisions[i].count + offset) / avrg));
        }else{
            this.decisions[i].label.css("color", interpolateColors("#dda21f", this.settings.color.colorGood, (this.decisions[i].count + offset - avrg) / (sum - avrg)));
        }
    }
}

registerScreen("TwitchEventVotes", new TwitchEventVotes());