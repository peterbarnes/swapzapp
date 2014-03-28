SwapzPOS.PurchasePrintRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('purchase');
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('templates', SwapzPOS.Template.all({per_page: 0, category: 'purchase'}));
  }
});