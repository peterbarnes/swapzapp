SwapzPOS.CustomersIndexRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    SwapzPOS.Customer.all().then(function(content) {
      controller.set('content', content);
    });
  }
});