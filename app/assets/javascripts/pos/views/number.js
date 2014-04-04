SwapzPOS.NumberField = Ember.TextField.extend({
  type: 'number',
  attributeBindings: ['min', 'max', 'step'],
  numbericValue : function (key, value) {
    if (arguments.length === 1) {
      return parseFloat(this.get('value'));
    } else {
      this.set('value', value !== undefined ? value + '' : '');
    }
  }.property('value'),
  didInsertElement: function() {
    this.$().keypress(function(key) {
      if((key.charCode!=46) && (key.charCode!=45) && (key.charCode < 48 || key.charCode > 57)) return false;
    })  
  }
})