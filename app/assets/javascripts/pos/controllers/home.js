SwapzPOS.HomeController = Ember.Controller.extend({
  needs: ['tillsAssign', 'tillAudit', 'tillTransfer', 'tillBarcode', 'timecardFlag'],
  body: null,
  messages: null,
  init: function () {
    this._super();
    this.set('messages', Ember.A());
  },
  receive: function() {
    var message = this.get('socket.messages.lastObject');
    if (message.chat) {
      var date = new Date();
      var _message = SwapzPOS.Message.create();
      _message.setProperties(message.chat);
      this.get('messages').insertAt(0, _message);
    }
  }.observes('socket.messages.lastObject'),
  actions: {
    clockIn: function() {
      var user = this.get('currentUser.content');
      user.clockIn();
    },
    clockOut: function() {
      var user = this.get('currentUser.content');
      user.clockOut();
    },
    flag: function(timecard) {
      this.get('controllers.timecardFlag').set('model', timecard);
      this.send('openModal', 'timecard.flag');
    },
    assign: function() {
      var controller = this;
      SwapzPOS.Till.all({
        unassigned: true, 
        per_page: 0, 
        store: true
      }).then(function (content) {
        controller.get('controllers.tillsAssign').set('content', content);
        controller.get('controllers.tillsAssign').set('tills', Ember.A());
        controller.send('openModal', 'tills.assign');
      });
    },
    unassign: function(till) {
      if (window.confirm('Are you sure you want to unassign this till?')) {
        var user = this.get('currentUser.content');
        user.removeTill(till);
        till.unassignUser();
      }
    },
    audit: function(till) {
      till.refresh(function() {
        this.get('controllers.tillAudit').set('model', till);
        this.get('controllers.tillAudit').send('reset');
        this.send('openModal', 'till.audit');
      }.bind(this));
    },
    transfer: function(till) {
      var controller = this;
      SwapzPOS.Till.all({
        per_page: 0, 
        store: true
      }).then(function (content) {
        till.refresh(function() {
          controller.get('controllers.tillTransfer').set('tills', content);
          controller.get('controllers.tillTransfer').set('model', till);
          controller.get('controllers.tillTransfer').send('reset');
          controller.send('openModal', 'till.transfer');
        });
      });
    },
    barcode: function(till) {
      this.get('controllers.tillBarcode').set('model', till);
      this.send('openModal', 'till.barcode');
      till.metadata(function(metadata) {
        this.get('controllers.tillBarcode').set('metadata', metadata);
      }.bind(this));
    },
    send: function() {
      var body = this.get('body');
      if (body) {
        var user = this.get('currentUser');
        var date = new Date();
        var socket = this.get('socket');
        socket.send({
          chat: {
            user: {
              first_name: user.get('firstName'),
              last_name: user.get('lastName'),
              username: user.get('username'),
              gravatar_url: user.get('gravatarUrl'),
            },
            body: body,
            date: date.toString()
          }
        });
      }
      this.set('body', null);
    },
    clear: function(message) {
      if (message) {
        this.get('messages').removeObject(message);
      } else {
        this.set('messages', Ember.A());
      }
    }
  }
});