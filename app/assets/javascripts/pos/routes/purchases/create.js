SwapzPOS.PurchasesCreateRoute = Ember.Route.extend({
  model: function() {
    return SwapzPOS.Purchase.create();
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