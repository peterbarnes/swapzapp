SwapzPOS.SalesIndexRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    SwapzPOS.Sale.all({
      user: true,
      store: true,
      customer: true,
      till: true,
      lines: true,
      payment: true
    }).then(function(content) {
      controller.set('content', content);
    });
  }
});