SwapzPOS.RepairsCreateRoute = Ember.Route.extend({
  model: function() {
    return SwapzPOS.Repair.create();
  },
  setupController: function(controller, model) {
    this.controllerFor('repair.edit').setProperties({ model: model });
  },
  renderTemplate: function() {
    this.render('repair/edit', {
      controller: 'repairEdit'
    });
  }
});