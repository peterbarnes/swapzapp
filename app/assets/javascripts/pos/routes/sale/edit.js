SwapzPOS.SaleEditRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('sale');
  },
  renderTemplate: function(controller, model){
    controller.send('reset');
    this._super(controller, model);
  }
});