SwapzPOS.ApplicationRoute = Ember.Route.extend({
  actions: {
    openModal: function(modal) {
      this.render(modal, {
        into: 'application',
        outlet: 'modal'
      });
    },
    closeModal: function() {
      this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    }
  }
});