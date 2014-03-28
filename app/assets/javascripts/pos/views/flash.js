SwapzPOS.FlashView = Ember.View.extend({
  templateName: 'views/flash',
  classNames: ['alert'],
  classNameBindings: ['alertSuccess', 'alertInfo', 'alertWarning', 'alertDanger'],
  messageBinding: 'model.message',
  alertSuccessBinding: 'model.isSuccess',
  alertInfoBinding: 'model.isInfo',
  alertWarningBinding: 'model.isWarning',
  alertDangerBinding: 'model.isDanger',
  isEmpty: Ember.computed.empty('message'),
  didInsertElement: function() {
    if(this.get('isEmpty')) {
      this.hide();
    }
  },
  onMessageChange: function() {
    this.get('isEmpty') ? this.hide() : this.show();
  }.observes('message'),
  hide: function() {
    this.$().hide();
  },
  show: function() {
    this.$().show();
    window.setTimeout(function() {
      this.$().hide();
    }.bind(this), 7000);
  },
  actions: {
    close: function() {
      this.get('model').clear();
    }
  }
});