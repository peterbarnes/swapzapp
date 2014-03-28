SwapzPOS.LineEditController = Ember.ObjectController.extend({
  actions: {
    addLine: function() {
      var lines = this.get('parent.lines');
      lines.addObject(this.get('model'));
    }
  }
});