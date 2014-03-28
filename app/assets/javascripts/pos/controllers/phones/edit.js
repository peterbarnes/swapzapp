SwapzPOS.PhonesEditController = Ember.ObjectController.extend({
  parent: null,
  actions: {
    done: function() {
      var parent = this.get('parent');
      parent.get('phones').addObject(this.get('model'));
    }
  }
});