SwapzPOS.CurrencyField = Ember.TextField.extend({
  type: 'number',
  attributeBindings: ['min', 'max', 'step'],
  currency: function(key, value) {
    if (arguments.length === 1) {
      return parseInt(this.get('value') * 100);
    } else {
      this.set('value', parseFloat((value * 10000) * 0.01) / 10000);
    }
  }.property('value'),
  didInsertElement: function() {
    this.$().keypress(function(key) {
      if((key.charCode != 46) && (key.charCode != 45) && (key.charCode < 48 || key.charCode > 57)) {
        return false;
      }
    });
  }
});