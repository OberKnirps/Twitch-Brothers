"use strict";

var TwitchCharacterNameScreen = function()
{
	this.mSQHandle = null;
	this.newBans = [];
}

TwitchCharacterNameScreen.prototype.onConnection = function (_handle)
{
    this.mSQHandle = _handle;
    var self = this;
    //SQ.call(self.mSQHandle , "logCallback","TEST12345");

    //wrap updateNameAndTitle()
    var oldFunc = Screens["WorldCharacterScreen"].mCharacterPanelModule.mCharacterPanelHeaderModule.updateNameAndTitle;
    Screens["WorldCharacterScreen"].mCharacterPanelModule.mCharacterPanelHeaderModule.updateNameAndTitle = function (_dialog)
    {
    	oldFunc.apply(Screens["WorldCharacterScreen"].mCharacterPanelModule.mCharacterPanelHeaderModule,[_dialog]);

    	//execute bans
    	for (var i = 0; i < self.newBans.length; i++) {
			SQ.call(self.mSQHandle , "logCallback",self.newBans[i]);
    		SQ.call(Screens["TwitchInterface"].mSQHandle, "banTwitchID", self.newBans[i]);
		}

		self.newBans = [];
    	//get ID of selected brother
   		var data = Screens["WorldCharacterScreen"].mCharacterPanelModule.mCharacterPanelHeaderModule.mDataSource.getSelectedBrother();
	    var selectedBrother = CharacterScreenIdentifier.Entity.Character.Key in data ? data[CharacterScreenIdentifier.Entity.Character.Key] : null;
	    if (selectedBrother === null)
	    {
	        console.error('Failed to create dialog content. Reason: No brother selected.');
	        return null;
	    }
	    var selectedBrotherId = data[CharacterScreenIdentifier.Entity.Id];

	    //get input fields
	    var contentContainer = _dialog.findPopupDialogContentContainer();
    	var inputFields = contentContainer.find('input');
    	
    	//update twitch name    	
    	SQ.call(self.mSQHandle, "updateTwitchInfo", {id: selectedBrotherId, twitchID:$(inputFields[2]).getInputText().toLowerCase()});
	}

	//wrap createChangeNameAndTitleDialogContent()
    var oldFunc2 = Screens["WorldCharacterScreen"].mCharacterPanelModule.mCharacterPanelHeaderModule.createChangeNameAndTitleDialogContent;    
    Screens["WorldCharacterScreen"].mCharacterPanelModule.mCharacterPanelHeaderModule.createChangeNameAndTitleDialogContent = function (_dialog)
    {
    	var result = oldFunc2.apply(Screens["WorldCharacterScreen"].mCharacterPanelModule.mCharacterPanelHeaderModule,[_dialog]);

    	//get ID of selected brother
   		var data = Screens["WorldCharacterScreen"].mCharacterPanelModule.mCharacterPanelHeaderModule.mDataSource.getSelectedBrother();
	    var selectedBrother = CharacterScreenIdentifier.Entity.Character.Key in data ? data[CharacterScreenIdentifier.Entity.Character.Key] : null;
	    if (selectedBrother === null)
	    {
	        console.error('Failed to create dialog content. Reason: No brother selected.');
	        return null;
	    }
	    var selectedBrotherId = data[CharacterScreenIdentifier.Entity.Id];

    	//find text fields and add buttons behind them
    	var layout = $('<div class="button"/>');
	    result.children().first().append(layout);
	    this.mDismissButton = layout.createImageButton(Path.GFX + Asset.BUTTON_DELAY_TURN, function (_event)
	    {
			var inputFields = result.find('input');

			SQ.call(self.mSQHandle , "getTwitchInfoOfID", $(inputFields[2]).getInputText().toLowerCase(), function(_data)
	    	{
				if(_data == null)
				{
					return;
				}
				else if(_data.Name.length)
				{
					$(inputFields[0]).setInputText(_data.Name);
				}
				else if(_data.DisplayName.length)
				{
					$(inputFields[0]).setInputText(_data.DisplayName);
				}
				else
				{
					$(inputFields[0]).setInputText(_data.TwitchID);
				}
	    	});
	    }, '', 6);
	    layout.bindTooltip({ contentType: 'msu-generic', modId: "mod_twitch_brothers", elementId: "changeNameDialog.updateName"});

	    var layout = $('<div class="button"/>');
	    result.children().last().append(layout);
	    this.mDismissButton = layout.createImageButton(Path.GFX + Asset.BUTTON_DELAY_TURN, function (_event)
	    {
			var inputFields = result.find('input');

			SQ.call(self.mSQHandle , "getTwitchInfoOfID", $(inputFields[2]).getInputText().toLowerCase(), function(_data)
	    	{
				if(_data == null)
				{
					return;
				}
				else if(_data.Title.length)
				{
					$(inputFields[1]).setInputText(_data.Title);
				}
	    	});
	    }, '', 6);
	    layout.bindTooltip({ contentType: 'msu-generic', modId: "mod_twitch_brothers", elementId: "changeNameDialog.updateTitle"});

	    //add new text fields and buttons
	    var row = $('<div class="row"/>');
	    result.append(row);
	    
	    var label = $('<div class="label text-font-normal font-color-label font-bottom-shadow">TwitchID</div>');
	    row.append(label);
	    
	    var inputLayout = $('<div class="l-input"/>');
	    row.append(inputLayout);

        var inputField = inputLayout.createInput('', 0, 100, 3, function (_input)
        	{
        		//calls this when text is updated
				inputField.bindTooltip({ contentType: 'msu-generic', modId: "mod_twitch_brothers", elementId: "changeNameDialog.inputTwitchID", twitchID: inputField.getInputText()});
        	}
        	, 'title-font-big font-bold font-color-brother-name', function (_input)
			{	
				//saves the changes if enter is pressed
				var button = _dialog.findPopupDialogOkButton();
				if(button.isEnabled())
					button.click();
			}
		);
		inputField.bindTooltip({ contentType: 'msu-generic', modId: "mod_twitch_brothers", elementId: "changeNameDialog.inputTwitchID", twitchID: inputField.getInputText().toLowerCase()});

    	SQ.call(self.mSQHandle , "getSelectedBroInfo", selectedBrotherId, function(_data)
    	{
    		if(_data == null)
			{
				return;
			}
			else
			{
	        	inputField.setInputText(_data.TwitchID);
			}
    	});

		var layout = $('<div class="button"/>');
	    row.append(layout);
	    this.mDismissButton = layout.createImageButton(Path.GFX + Asset.BUTTON_DELAY_TURN, function (_event)
	    {
	   		//function body
			var inputFields = result.find('input');

			SQ.call(self.mSQHandle , "getNewTwitchInfo", null, function(_data)
	    	{
				if(_data == null)
				{
					return;
				}
				else if(_data.TwitchID.length)
				{
					$(inputFields[2]).setInputText(_data.TwitchID);
				}
	    	});
	    }, '', 6);
	    layout.bindTooltip({ contentType: 'msu-generic', modId: "mod_twitch_brothers", elementId: "changeNameDialog.rerollTwitchID"});

	    //add free and ban button
	    row = $('<div class="row-small"/>');
	    result.append(row);

	   	var spacer = $('<div class="spacer"></div>');
	    row.append(spacer);
		
		var layout = $('<div class="button-text"/>');
	    row.append(layout);
	    this.mDismissButton = layout.createTextButton("Free", function (_event)
	    {
	   		//function body
	    	SQ.call(self.mSQHandle , "getSelectedBroInfo", selectedBrotherId, function(_data)
	    	{
    			var inputFields = result.find('input');

    			$(inputFields[0]).setInputText(_data.OriginalName);
    			$(inputFields[1]).setInputText(_data.OriginalTitle);
    			$(inputFields[2]).setInputText("");
	    	});

	    }, '', 1);
	    layout.bindTooltip({ contentType: 'msu-generic', modId: "mod_twitch_brothers", elementId: "changeNameDialog.freeTwitchID"});

	    layout = $('<div class="button-text"/>');
	    row.append(layout);
	    this.mDismissButton = layout.createTextButton("Ban", function (_event)
	    {
			var inputFields = result.find('input');
    		SQ.call(self.mSQHandle , "logCallback",$(inputFields[2]).getInputText());

	   		self.newBans.push($(inputFields[2]).getInputText().toLowerCase());

	    	SQ.call(self.mSQHandle , "getSelectedBroInfo", selectedBrotherId, function(_data)
	    	{
    			$(inputFields[0]).setInputText(_data.OriginalName);
    			$(inputFields[1]).setInputText(_data.OriginalTitle);
    			$(inputFields[2]).setInputText("");
	    	});
	    }, '', 1);
	    layout.bindTooltip({ contentType: 'msu-generic', modId: "mod_twitch_brothers", elementId: "changeNameDialog.banTwitchID"});

    	return result;
    }
}


registerScreen("TwitchCharacterNameScreen", new TwitchCharacterNameScreen());