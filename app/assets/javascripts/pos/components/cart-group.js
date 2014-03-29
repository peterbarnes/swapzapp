SwapzPOS.CartGroupComponent = Ember.Component.extend({
  purchase: false,
  actions: {
    addLine: function() {
      this.sendAction('edit', SwapzPOS.Line.create());
    },
    removeLines: function() {
      if (window.confirm('Are you sure you want to remove all lines in cart?')) {
        this.get('lines').forEach(function(line) {
          line.set('_remove', true);
        });
      }
    },
    editLine: function(line) {
      this.sendAction('edit', line);
    },
    removeLine: function(line) {
      line.set('_remove', true);
    }
  }
});