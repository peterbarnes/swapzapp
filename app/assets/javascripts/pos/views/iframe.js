SwapzPOS.IFrameView = Ember.View.extend({
  tagName: 'iframe',
  attributeBindings: ['src', 'seamless'],
  seamless: true,
  didInsertElement: function() {
    var iframe = this.$();
    iframe.load(function() {
      iframe.height(iframe.contents().height());
    })
  }
});
