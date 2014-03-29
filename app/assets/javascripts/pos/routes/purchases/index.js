SwapzPOS.PurchasesIndexRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    SwapzPOS.Purchase.all({
      user: true,
      store: true,
      customer: true,
      till: true
    }).then(function(content) {
      controller.set('content', content);
    });
  }
});