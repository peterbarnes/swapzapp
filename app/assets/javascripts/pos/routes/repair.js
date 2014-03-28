SwapzPOS.RepairRoute = Ember.Route.extend({
  model: function(params) {
    return SwapzPOS.Repair.find(params.repair_id, {customer: true});
  }
});