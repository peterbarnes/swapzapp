SwapzPOS.PhoneField = Ember.TextField.extend({
  type: 'phone',
  phone: function(key, number) {
    if (number) {
      if (number.length == 7) {
        number = number.replace(/(\d{3})(\d{4})/, '$1-$2');
      } else if (number.length == 10) {
        number = number.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
      } else if (number.length == 11) {
        number = number.replace(/(\d{1})(\d{3})(\d{3})(\d{4})/, '$1-$2-$3-$4');
      }
      this.set('value', number);
    } else {
      return this.get('value');
    }
  }.property('value')
});