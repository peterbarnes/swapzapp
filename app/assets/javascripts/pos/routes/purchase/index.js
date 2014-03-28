SwapzPOS.PurchaseIndexRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('purchase');
  }
});