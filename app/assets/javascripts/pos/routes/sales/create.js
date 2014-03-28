SwapzPOS.SalesCreateRoute = Ember.Route.extend({
  model: function() {
    return SwapzPOS.Sale.create();
  },
  setupController: function(controller, model) {
    this.controllerFor('sale.edit').setProperties({ model: model });
  },
  renderTemplate: function() {
    this.render('sale/edit', {
      controller: 'saleEdit'
    });
  }
});