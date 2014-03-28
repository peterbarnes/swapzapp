SwapzPOS.ModalDialogComponent = Ember.Component.extend({
  result: null,
  preventScroll: function() {
    $('body').css('overflow', 'hidden');
  }.on('didInsertElement'),
  restoreScroll: function() {
    $('body').css('overflow', 'auto');
  }.on('willClearRender'),
  actions: {
    close: function() {
      this.sendAction('close');
    },
    accept: function() {
      this.sendAction('accept');
      this.sendAction('close');
    }
  }
});