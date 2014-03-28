SwapzPOS.ProfileController = Ember.Controller.extend({
  saving: false,
  actions: {
    save: function() {
      var user = this.get('currentUser.content');
      if (user) {
        this.set('saving', true);
        user.save(function(response) {
          if (response) {
            this.get('flash').danger('Error updating profile: ' + JSON.stringify(response));
          } else {
            this.get('flash').success('Successfully updated profile!');
          }
          this.set('saving', false);
        }.bind(this));
      }
    }
  }
});