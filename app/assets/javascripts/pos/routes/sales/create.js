SwapzPOS.SalesCreateRoute = Ember.Route.extend({
  model: function() {
    var user = this.controllerFor('user').get('model');
    var till = user.get('tills.firstObject');
    var sale = SwapzPOS.Sale.create({
      user: user,
      till: till,
      store: till.store,
      taxRate: till.taxRate
    });
    return sale;
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