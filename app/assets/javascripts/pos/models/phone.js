SwapzPOS.Phone = Ember.Object.extend({
  id: null,
  name: null,
  number: null,
  _remove: null,
  replace: function() {
    this.set('number', this.get('number').replace(/\D/g, ''));
  }.observes('number'),
  formatted: function() {
    var number = this.get('number');
    if (number.length == 7) {
      return number.replace(/(\d{3})(\d{4})/, '$1-$2');
    } else if (number.length == 10) {
      return number.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
    } else if (number.length == 11) {
      return number.replace(/(\d{1})(\d{3})(\d{3})(\d{4})/, '$1-$2-$3-$4');
    }
    return number;
  }.property('number')
});