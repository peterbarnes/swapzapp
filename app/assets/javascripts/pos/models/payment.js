SwapzPOS.Payment = Ember.Object.extend({
  id: null,
  cash: 0,
  credit: 0,
  check: 0,
  giftCard: 0,
  storeCredit: 0,
  total: function() {
    return parseInt(this.get('cash')) + parseInt(this.get('credit')) + parseInt(this.get('check')) + parseInt(this.get('giftCard'));
  }.property('cash', 'credit', 'check', 'giftCard')
});