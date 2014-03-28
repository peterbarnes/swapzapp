Ember.Application.initializer({
  name: 'flash',
  initialize: function(container, application) {
    container.register('flash:main', SwapzPOS.Flash, {singleton: true});
    container.injection('controller', 'flash', 'flash:main');
  }
});