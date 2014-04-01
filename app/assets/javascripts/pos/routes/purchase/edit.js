SwapzPOS.PurchaseEditRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('purchase');
  },
  renderTemplate: function(controller, model){
    controller.send('reset');
    this._super(controller, model);
  }
});