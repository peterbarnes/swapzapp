Ember.Application.initializer({
  name: "socket",
  initialize: function(container, application) {
    container.register('socket:main', SwapzPOS.Socket, {singleton: true});
    container.injection('controller', 'socket', 'socket:main');
    
    var socket_url = $('meta[name="socket-url"]').attr('content');
    var attributes = $('meta[name="current-account"]').attr('content');
    if (attributes) {
      var socket = container.lookup('socket:main');
      var account = SwapzPOS.Account.create();
      account.setProperties(JSON.parse(attributes));
      socket.set('url', socket_url);
      socket.set('account', account);
    }
  }
});