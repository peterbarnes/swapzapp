SwapzPOS.SaleEditRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('sale');
  },
  renderTemplate: function(controller, model){
    this._super(controller, model);
  }
});