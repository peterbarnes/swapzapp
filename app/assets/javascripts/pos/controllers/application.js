SwapzPOS.ApplicationController = Ember.Controller.extend({
  actions: {
    lock: function() {
      $.cookie('_swapzapp_locked', true);
      this.set('currentUser.pinValue', "");
    },
    logout: function() {
      if (this.get('currentUser.isClockedIn')) {
        if (window.confirm('You are still clocked in! Are you sure?')) {
          window.location.href = '/logout';
        }
      } else {
        window.location.href = '/logout';
      }
    },
    menu: function() {
      $('.content').toggleClass('full');
      $('.sidebar-nav').toggleClass('hide');
    }
  }
});