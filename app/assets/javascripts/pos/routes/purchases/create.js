SwapzPOS.PurchasesCreateRoute = Ember.Route.extend({
  model: function() {
    var user = this.controllerFor('user').get('model');
    var till = user.get('tills.firstObject');
    var purchase = SwapzPOS.Purchase.create({
      user: user,
      till: till,
      store: till.store,
      taxRate: till.taxRate
    });
    return purchase;
  },
  setupController: function(controller, model) {
    this.controllerFor('purchase.edit').setProperties({ model: model });
  },
  renderTemplate: function() {
    this.render('purchase/edit', {
      controller: 'purchaseEdit'
    });
  }
});