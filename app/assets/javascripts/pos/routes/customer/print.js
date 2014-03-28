SwapzPOS.CustomerPrintRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('customer');
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('templates', SwapzPOS.Template.all({per_page: 0, category: 'customer'}));
  }
});