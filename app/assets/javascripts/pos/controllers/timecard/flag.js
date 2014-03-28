SwapzPOS.TimecardFlagController = Ember.ObjectController.extend({
  actions: {
    flag: function() {
      var timecard = this.get('model');
      timecard.flag(this.get('note'));
    }
  }
});