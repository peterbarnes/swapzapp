SwapzPOS.PurchaseIndexController = Ember.ObjectController.extend({
  actions: {
    edit: function() {
      this.transitionToRoute('purchase.edit', this.get('model.id'));
    },
    print: function() {
      this.transitionToRoute('purchase.print', this.get('model.id'));
    }
  }
});