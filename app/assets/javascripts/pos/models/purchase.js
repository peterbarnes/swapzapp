SwapzPOS.Purchase = SwapzPOS.Base.extend({
  sku: null,
  complete: false,
  completedAt: null,
  flagged: false,
  note: null,
  cash: 0,
  credit: 0,
  ratio: 0,
  creditBalance: null,
  configurable: null,
  customer_id: null,
  customer: null,
  till_id: null,
  till: null,
  store_id: null,
  store: null,
  user_id: null,
  user: null,
  lines: null,
  init: function() {
    this._super();
    this.set('lines', Ember.A());
  },
  quantity: function() {
    var lines = this.get('lines');
    var quantity = 0;
    lines.forEach(function(line) {
      if (!line.get('_remove')) {
        quantity += line.get('quantity');
      }
    });
    return quantity;
  }.property('lines', 'lines.@each', 'lines.@each.quantity', 'lines.@each._remove'),
  cashSubtotal: function() {
    var lines = this.get('lines');
    var subtotal = 0;
    lines.forEach(function(line) {
      if (!line.get('_remove')) {
        subtotal += line.get('subtotalCash');
      }
    });
    return subtotal;
  }.property('lines', 'lines.@each', 'lines.@each.subtotalCash', 'lines.@each._remove'),
  creditSubtotal: function() {
    var lines = this.get('lines');
    var subtotal = 0;
    lines.forEach(function(line) {
      if (!line.get('_remove')) {
        subtotal += line.get('subtotalCredit');
      }
    });
    return subtotal;
  }.property('lines', 'lines.@each', 'lines.@each.subtotalCredit', 'lines.@each._remove'),
  due: function() {
    return this.get('cash');
  }.property('cash'),
  dueLabel: function() {
    return "Change Due:";
  }.property(),
  saveable: function() {
    return !this.get('complete');
  }.property('complete'),
  nonSaveable: function() {
    return !this.get('saveable');
  }.property('saveable'),
  completable: function() {
    return !this.get('complete') && this.get('user') && this.get('customer') && this.get('till') && this.get('quantity') > 0 && this.get('due') >= 0;
  }.property('user', 'till', 'customer', 'quantity', 'due'),
  nonCompletable: function() {
    return !this.get('completable');
  }.property('completable'),
  cashChanged: function() {
    var cash = this.get('cash');
    var cashSubtotal = this.get('cashSubtotal');
    var ratio = cash / cashSubtotal;
    if (ratio < 0 || isNaN(ratio)) { ratio = 0; }
    if (ratio > 1) { ratio = 1; }
    this.set('ratio', 1 - ratio);
  }.observes('cash').on('init'),
  creditChanged: function() {
    var credit = this.get('credit');
    var creditSubtotal = this.get('creditSubtotal');
    var ratio = credit / creditSubtotal;
    if (ratio < 0 || isNaN(ratio)) { ratio = 0; }
    if (ratio > 1) { ratio = 1; }
    this.set('ratio', ratio);
  }.observes('credit').on('init'),
  ratioChanged: function() {
    var ratio = this.get('ratio');
    var cashSubtotal = this.get('cashSubtotal');
    var creditSubtotal = this.get('creditSubtotal');
    this.set('cash', parseInt(Math.round(cashSubtotal * (1-ratio))));
    this.set('credit', parseInt(Math.round(creditSubtotal * ratio)));
  }.observes('ratio', 'cashSubtotal', 'creditSubtotal').on('init')
});

SwapzPOS.Purchase.reopenClass({
  singular: 'purchase',
  plural: 'purchases'
});

SwapzPOS.Purchase.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.purchase, {
      complete: this.get('complete'),
      flagged: this.get('flagged'),
      ratio: this.get('ratio'),
      note: this.get('note'),
      customer_id: this.get('customer_id'),
      till_id: this.get('till_id'),
      store_id: this.get('store_id'),
      user_id: this.get('user_id'),
      lines_attributes: []
    });
    if (this.get('sku')) {
      entity.purchase.sku = this.get('sku');
    }
    if (this.get('customer')) {
      entity.purchase.customer_id = this.get('customer.id');
    }
    if (this.get('till')) {
      entity.purchase.till_id = this.get('till.id');
    }
    if (this.get('store')) {
      entity.purchase.store_id = this.get('store.id');
    }
    if (this.get('user')) {
      entity.purchase.user_id = this.get('user.id');
    }
    this.get('lines').forEach(function(line) {
      var _line = {
        amount: line.get('amount'),
        amount_cash: line.get('amountCash'),
        amount_credit: line.get('amountCredit'),
        bullets: line.get('bullets'),
        inventory: line.get('inventory'),
        certificate_id: line.get('certificate_id'),
        unit_id: line.get('unit_id'),
        item_id: line.get('item_id'),
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
      entity.purchase.lines_attributes.addObject(_line);
    });
    return entity;
  },
  assign: function(data) {
    this._super(data);
    this.setProperties({
      sku: data.sku,
      complete: data.complete,
      flagged: data.flagged,
      ratio: parseFloat(data.ratio),
      creditBalance: data.credit_balance,
      note: data.note,
      customer_id: data.customer_id,
      till_id: data.till_id,
      store_id: data.store_id,
      user_id: data.user_id,
    });
    if (data.completed_at) {
      this.set('completedAt', new Date(data.completed_at));
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
    if (data.lines) {
      var lines = [];
      data.lines.forEach(function(_line){
        var line = SwapzPOS.Line.create({
          id: _line.id,
          amount: _line.amount,
          amountCash: _line.amount_cash,
          amountCredit: _line.amount_credit,
          inventory: _line.inventory,
          certificate_id: _line.certificate_id,
          unit_id: _line.unit_id,
          item_id: _line.item_id,
          quantity: _line.quantity,
          note: _line.note,
          sku: _line.sku,
          title: _line.title,
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