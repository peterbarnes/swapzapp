SwapzPOS.TillTransferController = Ember.ObjectController.extend({
  tills: null,
  destination: null,
  description: null,
  amount: 0,
  actions: {
    transfer: function() {
      var till = this.get('model');
      var destination = this.get('destination');
      if (till && destination) {
        var date = new Date();
        var user = till.get('user');
        var adjustment = SwapzPOS.Adjustment.create();
        var adjustment_r = SwapzPOS.Adjustment.create();
      
        adjustment.set('amount', parseInt(this.get('amount') * 100 * -1));
        adjustment.set('balance', till.get('balance'));
        adjustment.set('user', user);
        adjustment.set('description', this.get('description'));
        adjustment.set('title', "Transfer to " + destination.get('name') + " " + date + " (" + user.get('fullname') + ")");
      
        adjustment_r.set('amount', parseInt(this.get('amount') * 100));
        adjustment_r.set('balance', destination.get('balance'));
        adjustment_r.set('user', user);
        adjustment_r.set('description', this.get('description'));
        adjustment_r.set('title', "Transfer from " + till.get('name') + " " + date + " (" + user.get('fullname') + ")");
      
        till.get('adjustments').push(adjustment);
        destination.get('adjustments').push(adjustment_r);
      
        till.save(function() {
          destination.save();
        });
      }
    },
    reset: function() {
      this.set('destination', null);
      this.set('description', null);
      this.set('amount', 0);
    }
  }
});