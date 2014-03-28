SwapzPOS.SaleIndexController = Ember.ObjectController.extend({
  actions: {
    edit: function() {
      this.transitionToRoute('sale.edit', this.get('model.id'));
    },
    print: function() {
      this.transitionToRoute('sale.print', this.get('model.id'));
    }
  }
});