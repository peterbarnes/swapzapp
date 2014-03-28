SwapzPOS.Line = Ember.Object.extend({
  id: null,
  amount: 0,
  amountCash: 0,
  amountCredit: 0,
  bullets: null,
  quantity: 0,
  note: null,
  sku: null,
  taxable: true,
  title: null,
  certificate_id: null,
  certificate: null,
  unit_id: null,
  unit: null,
  item_id: null,
  item: null,
  _remove: false,
  init: function() {
    this._super();
    this.set('bullets', Ember.A());
  },
  editable: function() {
    if (this.get('certificate') || this.get('unit') || this.get('item')) {
      return false;
    }
    return true;
  }.property('certificate', 'unit', 'item'),
  subtotal: function() {
    return parseInt(this.get('amount')) * parseInt(this.get('quantity'));
  }.property('amount', 'quantity'),
  cashSubtotal: function() {
    return parseInt(this.get('amountCash')) * parseInt(this.get('quantity'));
  }.property('amountCash', 'quantity'),
  creditSubtotal: function() {
    return parseInt(this.get('amountCredit')) * parseInt(this.get('quantity'));
  }.property('amountCredit', 'quantity')
});