Ember.Application.initializer({
  name: 'account',
  initialize: function(container) {
    var attributes = $('meta[name="current-account"]').attr('content');
    if (attributes) {
      var account = SwapzPOS.Account.create();
      account.setProperties(JSON.parse(attributes));
      var controller = container.lookup('controller:account').set('content', account);
      return container.typeInjection('controller', 'currentAccount', 'controller:account');
    }
  }
});