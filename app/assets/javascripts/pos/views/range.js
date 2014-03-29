SwapzPOS.RangeField = Ember.TextField.extend({
  type: 'range',
  attributeBindings: ['min', 'max', 'step']
});