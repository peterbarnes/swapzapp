SwapzPOS.PurchaseEditRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('purchase');
  },
  renderTemplate: function(controller, model){
    this._super(controller, model);
  }
});