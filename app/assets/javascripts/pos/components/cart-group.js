SwapzPOS.CartGroupComponent = Ember.Component.extend({
  actions: {
    addLine: function() {
      this.sendAction('edit', SwapzPOS.Line.create());
    },
    removeLines: function() {
      if (window.confirm('Are you sure you want to remove all lines in cart?')) {
        this.get('lines').setObjects([]);
      }
    },
    editLine: function(line) {
      this.sendAction('edit', line);
    },
    pinLine: function(line) {
      
    },
    removeLine: function(line) {
      this.get('lines').removeObject(line);
    }
  }
});