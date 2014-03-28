SwapzPOS.PurchasePrintRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('purchase');
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    SwapzPOS.Template.all({
      per_page: 0, 
      category: 'purchase'
    }).then(function(content) {
      controller.set('templates', content);
    });
  }
});