SwapzPOS.RepairIndexController = Ember.ObjectController.extend({
  actions: {
    edit: function() {
      this.transitionToRoute('repair.edit', this.get('model.id'));
    },
    print: function() {
      this.transitionToRoute('repair.print', this.get('model.id'));
    }
  }
});