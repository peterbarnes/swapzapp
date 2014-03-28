Ember.Application.initializer({
  name: "clock",
  initialize: function(container, application) {
    container.register('clock:main', SwapzPOS.Clock, {singleton: true});
    container.injection('controller', 'clock', 'clock:main');
  }
});