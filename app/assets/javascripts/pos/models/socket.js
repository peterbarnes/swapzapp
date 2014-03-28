SwapzPOS.Socket = Ember.Object.extend({
  url: null,
  account: null,
  messages: null,
  socket: null,
  init: function() {
    this.set('messages', Ember.A());
  },
  connect: function() {
    try {
      var account = this.get('account');
      var _socket = io.connect(this.get('url') + '/' + account.get('namespace'));
      var socket = this;
      _socket.on('message', function(data) {
        if (data.data) {
          socket.get('messages').addObject(data.data);
        }
      });
      this.set('socket', _socket);
    } catch(error) {
      console.log(error);
    }
  }.observes('account'),
  send: function(data) {
    var socket = this.get('socket');
    if (socket) {
      socket.emit('message', {data: data});
    }
  }
});