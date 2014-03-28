Ember.Application.initializer({
  name: 'user',
  initialize: function(container) {
    var attributes = $('meta[name="current-user"]').attr('content');
    if (attributes) {
      var user = SwapzPOS.User.create();
      user.assign(JSON.parse(attributes));
      var controller = container.lookup('controller:user').set('content', user);
      return container.typeInjection('controller', 'currentUser', 'controller:user');
    }
  }
});