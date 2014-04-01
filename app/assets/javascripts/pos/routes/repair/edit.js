SwapzPOS.RepairEditRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('repair');
  },
  renderTemplate: function(controller, model){
    controller.send('reset');
    this._super(controller, model);
  }
});