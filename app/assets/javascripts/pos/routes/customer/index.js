SwapzPOS.CustomerIndexRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('customer');
  }
});