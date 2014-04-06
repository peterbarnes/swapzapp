SwapzPOS.Sale = SwapzPOS.Base.extend({
  complete: null,
  completedAt: null,
  configurable: null,
  certificate_id: null,
  certificate: null,
  customer_id: null,
  customer: null,
  flagged: null,
  lines: null,
  note: null,
  payment: null,
  sku: null,
  taxRate: null,
  till_id: null,
  till: null,
  store_id: null,
  store: null,
  user_id: null,
  user: null,
  init: function() {
    this._super();
    this.set('complete', false);
    this.set('lines', Ember.A());
    this.set('payment', SwapzPOS.Payment.create());
  },
  quantity: function() {
    var lines = this.get('lines');
    var quantity = 0;
    lines.forEach(function(line) {
      if (!line.get('_remove')) {
        quantity += parseInt(line.get('quantity'));
      }
    });
    return quantity;
  }.property('lines', 'lines.@each', 'lines.@each.quantity', 'lines.@each._remove'),
  subtotal: function() {
    var lines = this.get('lines');
    var subtotal = 0;
    lines.forEach(function(line) {
      if (!line.get('_remove')) {
        subtotal += line.get('subtotal');
      }
    });
    return subtotal;
  }.property('taxRate', 'lines', 'lines.@each', 'lines.@each.subtotal', 'lines.@each._remove'),
  subtotalAfterStoreCredit: function() {
    return this.get('subtotal') - this.get('payment.storeCredit');
  }.property('taxRate', 'lines', 'lines.@each', 'lines.@each.subtotal', 'lines.@each._remove', 'payment.storeCredit'),
  taxableSubtotal: function() {
    var lines = this.get('lines');
    var subtotal = 0;
    lines.forEach(function(line) {
      if (line.get('taxable') &&  !line.get('_remove')) {
        subtotal += line.get('subtotal');
      }
    });
    return subtotal;
  }.property('taxRate', 'lines', 'lines.@each', 'lines.@each.subtotal', 'lines.@each.taxable', 'lines.@each._remove'),
  tax: function() {
    var subtotal = this.get('subtotal') - this.get('payment.storeCredit');
    if (subtotal > 0) {
      var taxableSubtotal = this.get('taxableSubtotal') - this.get('payment.storeCredit');
      if (taxableSubtotal > 0) {
        return parseInt(Math.round(taxableSubtotal * this.get('taxRate')));
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }.property('taxRate', 'lines', 'lines.@each', 'lines.@each.subtotal', 'lines.@each.taxable', 'lines.@each._remove', 'payment.storeCredit'),
  total: function() {
    return this.get('subtotalAfterStoreCredit') + this.get('tax');
  }.property('taxRate', 'lines', 'lines.@each', 'lines.@each.subtotal', 'lines.@each._remove', 'payment.storeCredit'),
  due: function() {
    return this.get('total') - this.get('payment.total');
  }.property('taxRate', 'total', 'payment.storeCredit', 'payment.giftCard', 'payment.check', 'payment.credit', 'payment.cash'),
  dueLabel: function() {
    var due = this.get('due')
    if (due > 0) {
      return "Amount Due:";
    } else {
      return "Change Due:";
    }
  }.property('due'),
  saveable: function() {
    return !this.get('complete');
  }.property('complete'),
  nonSaveable: function() {
    return !this.get('saveable');
  }.property('saveable'),
  completable: function() {
    return !this.get('complete') && this.get('user') && this.get('store') && this.get('till') && this.get('payment') && this.get('quantity') > 0 && this.get('due') <= 0;
  }.property('complete', 'user', 'store', 'till', 'payment', 'quantity', 'due'),
  nonCompletable: function() {
    return !this.get('completable');
  }.property('completable')
});

SwapzPOS.Sale.reopenClass({
  singular: 'sale',
  plural: 'sales'
});

SwapzPOS.Sale.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.sale, {
      complete: this.get('complete'),
      flagged: this.get('flagged'),
      tax_rate: this.get('taxRate'),
      note: this.get('note'),
      certificate_id: this.get('certificate_id'),
      customer_id: this.get('customer_id'),
      till_id: this.get('till_id'),
      user_id: this.get('user_id'),
      store_id: this.get('store_id'),
      lines_attributes: [],
      payment_attributes: null
    });
    if (this.get('sku')) {
      entity.sale.sku = this.get('sku');
    }
    if (this.get('certificate')) {
      entity.sale.certificate_id = this.get('certificate.id');
    }
    if (this.get('customer')) {
      entity.sale.customer_id = this.get('customer.id');
    }
    if (this.get('till')) {
      entity.sale.till_id = this.get('till.id');
    }
    if (this.get('store')) {
      entity.sale.store_id = this.get('store.id');
    }
    if (this.get('user')) {
      entity.sale.user_id = this.get('user.id');
    }
    if (this.get('payment')) {
      entity.sale.payment_attributes = {
        id: this.get('payment.id'),
        cash: this.get('payment.cash'),
        credit: this.get('payment.credit'),
        check: this.get('payment.check'),
        gift_card: this.get('payment.giftCard'),
        store_credit: this.get('payment.storeCredit')
      }
      if (this.get('payment.id')) {
        entity.sale.payment_attributes.id = this.get('payment.id');
      }
    }
    this.get('lines').forEach(function(line) {
      var _line = {
        amount: line.get('amount'),
        amount_cash: line.get('amountCash'),
        amount_credit: line.get('amountCredit'),
        bullets: line.get('bullets'),
        inventory: line.get('inventory'),
        certificate: line.get('certificate'),
        quantity: line.get('quantity'),
        note: line.get('note'),
        sku: line.get('sku'),
        taxable: line.get('taxable'),
        title: line.get('title'),
        _destroy: line.get('_remove')
      };
      if (line.get('id')) {
        _line.id = line.get('id');
      }
      if (line.get('certificate')) {
        _line.certificate_id = line.get('certificate.id');
      }
      if (line.get('unit')) {
        _line.unit_id = line.get('unit.id');
      }
      if (line.get('item')) {
        _line.item_id = line.get('item.id');
      }
      entity.sale.lines_attributes.addObject(_line);
    });
    return entity;
  },
  assign: function(data) {
    this._super(data);
    this.setProperties({
      sku: data.sku,
      complete: data.complete,
      flagged: data.flagged,
      taxRate: data.tax_rate,
      note: data.note,
      certificate_id: data.certificate_id,
      customer_id: data.customer_id,
      till_id: data.till_id,
      user_id: data.user_id,
      store_id: data.store_id,
    });
    if (data.completed_at) {
      this.set('completedAt', new Date(data.completed_at));
    }
    if (data.certificate) {
      this.set('certificate', SwapzPOS.Certificate.create().assign(data.certificate));
    }
    if (data.customer) {
      this.set('customer', SwapzPOS.Customer.create().assign(data.customer));
    }
    if (data.user) {
      this.set('user', SwapzPOS.User.create().assign(data.user));
    }
    if (data.till) {
      this.set('till', SwapzPOS.Till.create().assign(data.till));
    }
    if (data.store) {
      this.set('store', SwapzPOS.Store.create().assign(data.store));
    }
    if (data.payment) {
      this.set('payment', SwapzPOS.Payment.create({
        id: data.payment.id,
        cash: data.payment.cash,
        credit: data.payment.credit,
        check: data.payment.check,
        giftCard: data.payment.gift_card,
        storeCredit: data.payment.store_credit
      }));
    }
    if (data.lines) {
      var lines = [];
      data.lines.forEach(function(_line){
        var line = SwapzPOS.Line.create({
          id: _line.id,
          amount: _line.amount,
          amountCash: _line.amount_cash,
          amountCredit: _line.amount_credit,
          inventory: _line.inventory,
          certificate: _line.certificate,
          quantity: _line.quantity,
          note: _line.note,
          sku: _line.sku,
          taxable: _line.taxable,
          title: _line.title
        });
        if (_line.certificate) {
          line.set('certificate', SwapzPOS.Certificate.create().assign(_line.certificate));
        }
        if (_line.unit) {
          line.set('unit', SwapzPOS.Unit.create().assign(_line.unit));
        }
        if (_line.item) {
          line.set('item', SwapzPOS.Item.create().assign(_line.item));
        }
        line.set('bullets', _line.bullets);
        lines.addObject(line);
      });
      this.set('lines', lines);
    }
    return this;
  }
});