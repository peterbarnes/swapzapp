SwapzPOS.Certificate = SwapzPOS.Base.extend({
  active: false,
  amount: 0,
  amountFmt: 0,
  balance: 0,
  sku: null,
  customer_id: null,
  customer: null,
  _selected: false,
  init: function() {
    this._super();
  },
  amountFmt: function(key, value) {
    if (arguments.length > 1) {
      this.set('amount', parseInt(Math.round(1000 * value * 100) / 1000));
      if (this.get('id') == null) {
        this.set('balance', this.get('amount'));
      }
    }
    return (this.get('amount') * 0.01).toFixed(2);
  }.property('amount'),
  balanceFmt: function(key, value) {
    if (arguments.length > 1) {
      this.set('balance', parseInt(Math.round(1000 * value * 100) / 1000));
    }
    return (this.get('balance') * 0.01).toFixed(2);
  }.property('balance')
});

SwapzPOS.Certificate.reopenClass({
  singular: 'certificate',
  plural: 'certificates'
});

SwapzPOS.Certificate.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.certificate, {
      active: this.get('active'),
      amount: this.get('amount'),
      balance: this.get('balance'),
      sku: this.get('sku'),
      customer_id: this.get('customer_id')
    });
    if (this.get('customer')) {
      entity.sale.customer_id = this.get('customer.id');
    }
    return entity;
  },
  assign: function(data) {
    this._super(data);
    this.setProperties({
      active: data.active,
      amount: data.amount,
      balance: data.balance,
      sku: data.sku,
      customer_id: data.customer_id
    });
    if (data.customer) {
      this.set('customer', SwapzPOS.Customer.create().assign(data.customer));
    }
    return this;
  }
});