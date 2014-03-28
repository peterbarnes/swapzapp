SwapzPOS.RepairIndexRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('repair');
  }
});