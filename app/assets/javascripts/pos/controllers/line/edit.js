SwapzPOS.LineEditController = Ember.ObjectController.extend({
  purchase: false,
  actions: {
    addLine: function() {
      var lines = this.get('parent.lines');
      lines.addObject(this.get('model'));
    }
  }
});