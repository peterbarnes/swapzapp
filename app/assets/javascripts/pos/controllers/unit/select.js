SwapzPOS.UnitSelectController = Ember.ArrayController.extend({
  units: [],
  actions: {
    select: function(unit) {
      var units = this.get('units');
      if (units.contains(unit)) {
        this.get('units').removeObject(unit);
      } else {
        this.get('units').addObject(unit);
      }
      unit.set('_selected', !unit.get('_selected'));
    },
    addToCart: function() {
      _controller = this;
      _controller.get('units').forEach(function(unit) {
        _controller.get('parent').send('addUnitLine', unit);
      });
    }
  }
});