SwapzPOS.LockView = Ember.View.extend({
  templateName: 'views/lock',
  classNames: ['lock-screen'],
  classNameBindings: ['hide'],
  hideBinding: 'model.authenticated',
  pin: null,
  didInsertElement: function() {
    if ($.cookie('_swapzapp_locked')) {
      this.set('model.pinValue', "");
    }
  },
  actions: {
    unlock: function() {
      this.set('model.pinValue', this.get('pin'));
      if (this.get('model.authenticated')) {
        $.removeCookie('_swapzapp_locked');
        this.set('pin', null);
      }
    },
    logout: function() {
      $.removeCookie('_swapzapp_locked');
      window.location.href = '/logout';
    }
  }
});