SwapzPOS.SalePrintRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('sale');
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    SwapzPOS.Template.all({
      per_page: 0, 
      category: 'sale'
    }).then(function(content) {
      controller.set('templates', content);
    });
  }
});