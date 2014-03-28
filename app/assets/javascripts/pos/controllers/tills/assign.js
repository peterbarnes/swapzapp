SwapzPOS.TillsAssignController = Ember.ArrayController.extend({
  tills: null,
  actions: {
    assign: function() {
      var user = this.get('currentUser');
      var tills = this.get('tills');
      tills.forEach(function(till) {
        till.set('user', user);
        till.save();
        user.get('tills').addObject(till);
      });
    },
    select: function(till) {
      var tills = this.get('tills');
      if (tills.contains(till)) {
        this.get('tills').removeObject(till);
      } else {
        this.get('tills').addObject(till);
      }
      till.set('_selected', !till.get('_selected'));
    }
  }
});