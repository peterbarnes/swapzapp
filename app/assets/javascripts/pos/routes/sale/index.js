SwapzPOS.SaleIndexRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('sale');
  }
});