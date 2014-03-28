SwapzPOS.RepairsIndexRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    SwapzPOS.Repair.all({
      customer: true,
      location: true,
      store: true,
      till: true,
      logs: true,
      lines: true
    }).then(function(content) {
      controller.set('content', content);
    });
  }
});