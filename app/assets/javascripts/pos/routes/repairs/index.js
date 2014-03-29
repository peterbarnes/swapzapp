SwapzPOS.RepairsIndexRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    SwapzPOS.Repair.all({
      customer: true,
      store: true,
      till: true,
      user: true
    }).then(function(content) {
      controller.set('content', content);
    });
  }
});