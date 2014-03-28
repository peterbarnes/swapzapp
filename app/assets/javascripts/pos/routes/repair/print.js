SwapzPOS.RepairPrintRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('repair');
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    SwapzPOS.Template.all({
      per_page: 0, 
      category: 'repair'
    }).then(function(content) {
      controller.set('templates', content);
    });
  }
});