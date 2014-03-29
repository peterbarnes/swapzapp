SwapzPOS.RepairsCreateRoute = Ember.Route.extend({
  model: function() {
    var user = this.controllerFor('user').get('model');
    var till = user.get('tills.firstObject');
    var repair = SwapzPOS.Repair.create({
      user: user,
      till: till,
      store: till.store,
      taxRate: till.taxRate
    });
    return repair;
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