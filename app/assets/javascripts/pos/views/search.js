SwapzPOS.SearchField = Ember.TextField.extend({
  type: 'search',
  attributeBindings: ['results', 'autosave'],
  becomeFocused: function() {
    this.$().focus();
  }.on('didInsertElement')
})