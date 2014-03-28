SwapzPOS.CustomerEditRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('customer');
  }
});