SwapzPOS.CustomersCreateRoute = Ember.Route.extend({
  model: function() {
    return SwapzPOS.Customer.create();
  },
  setupController: function(controller, model) {
    this.controllerFor('customer.edit').setProperties({ model: model });
  },
  renderTemplate: function() {
    this.render('customer/edit', {
      controller: 'customerEdit'
    });
  }
});