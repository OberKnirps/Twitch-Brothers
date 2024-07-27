this.twitch_event_votes <- 
{
    m = 
    {
        JSHandle = null
    },

    function create()
    {}
    
    function onInit()
    {}

    function destroy()
    {
        if (this.m.JSHandle != null)
        {
            this.m.JSHandle = this.UI.disconnect(this.m.JSHandle);
        }
    }

    function connect()
    {
        this.m.JSHandle = ::UI.connect("TwitchEventVotes",this);
        this.updateSettings();
    }

    function updateSettings()
    {
        if(this.m.JSHandle == null) return;
        local settings = 
        {
            active = ::TwitchBrothers.Content.Settings.Event.Active.getValue(),
            timer =
            {
                active = ::TwitchBrothers.Content.Settings.Event.Timer.Active.getValue(),
                waitForVote = ::TwitchBrothers.Content.Settings.Event.Timer.WaitForVote.getValue(),
                duration = ::TwitchBrothers.Content.Settings.Event.Timer.Duration.getValue(), 
                selection = 
                {
                    manual = ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Manual.getValue(),
                    auto = ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Auto.getValue(),
                    duration = ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Duration.getValue(), 
                    speed = ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Speed.getValue(), 
                    delay = ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Delay.getValue()
                },
                randomizeChoice =
                {
                    active = ::TwitchBrothers.Content.Settings.Event.Timer.RandomizeChoice.Active.getValue(),
                    duration = ::TwitchBrothers.Content.Settings.Event.Timer.RandomizeChoice.Duration.getValue(),
                    speed = ::TwitchBrothers.Content.Settings.Event.Timer.RandomizeChoice.Speed.getValue()
                }        
            },
            color =
            {
                active = ::TwitchBrothers.Content.Settings.Event.Color.Active.getValue(),
                colorGood = ::TwitchBrothers.Content.Settings.Event.Color.ColorGood.getValueAsHexString(),
                colorBad = ::TwitchBrothers.Content.Settings.Event.Color.ColorBad.getValueAsHexString(),
                voteOffset = ::TwitchBrothers.Content.Settings.Event.Color.VoteOffset.getValue()
            }
        }
        ::Const.TwitchEventVotes.m.JSHandle.asyncCall("updateSettings", settings);
    }
};

