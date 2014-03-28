SwapzPOS.AddressesEditController = Ember.ObjectController.extend({
  parent: null,
  actions: {
    done: function() {
      var parent = this.get('parent');
      parent.get('addresses').addObject(this.get('model'));
    }
  }
});