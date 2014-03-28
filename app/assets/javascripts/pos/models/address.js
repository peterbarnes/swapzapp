SwapzPOS.Address = Ember.Object.extend({
  id: null,
  city: null,
  country: null,
  firstLine: null,
  name: null,
  secondLine: null,
  state: null,
  type: null,
  zip: null,
  _remove: false,
  formatted: function() {
    return this.get('firstLine') + ' ' + this.get('secondLine') + ' ' + this.get('city') + ' ' + this.get('state') + ', ' + this.get('zip') + ' ' + this.get('country');
  }.property('city', 'country', 'firstLine', 'secondLine', 'state', 'type', 'zip')
});