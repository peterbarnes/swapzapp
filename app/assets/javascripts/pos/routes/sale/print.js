SwapzPOS.SalePrintRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('sale');
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('templates', SwapzPOS.Template.all({per_page: 0, category: 'sale'}));
  }
});