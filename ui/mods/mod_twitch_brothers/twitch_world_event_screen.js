var oldFunc = WorldEventScreen.prototype.renderButtons;
WorldEventScreen.prototype.renderButtons = function (_data, _hasBigButtons)
{
	oldFunc.apply(this,[_data, _hasBigButtons]);
    var rows = this.mButtonContainer.children();

    for (var i = 0; i < rows.length; i++) 
    {
        var eventId = $('<div class="event-id text-font-normal font-color-label font-bottom-shadow">' + i+1 + '</div>');
        var eventCounter = $('<div class="event-counter text-font-normal font-color-label font-bottom-shadow">' + 0 + '</div>');
        
        var currentRow = rows.eq(i);
        currentRow.append(eventId);
        currentRow.append(eventCounter);
    }
}