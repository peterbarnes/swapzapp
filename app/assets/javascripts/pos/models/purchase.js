SwapzPOS.Purchase = SwapzPOS.Base.extend({
  sku: null,
  complete: false,
  completedAt: null,
  flagged: false,
  note: null,
  cash: 0,
  credit: 0,
  ratio: 0,
  configurable: null,
  customer: null,
  till: null,
  store: null,
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
      if (!line.get('_destroy')) {
        quantity += line.get('quantity');
      }
    });
    return quantity;
  }.property('lines', 'lines.@each', 'lines.@each.quantity', 'lines.@each.remove'),
  cashSubtotal: function() {
    var lines = this.get('lines');
    var subtotal = 0;
    lines.forEach(function(line) {
      if (!line.get('_destroy')) {
        subtotal += line.get('cashSubtotal');
      }
    });
    return subtotal;
  }.property('lines', 'lines.@each', 'lines.@each.cashSubtotal', 'lines.@each.remove'),
  creditSubtotal: function() {
    var lines = this.get('lines');
    var subtotal = 0;
    lines.forEach(function(line) {
      if (!line.get('_destroy')) {
        subtotal += line.get('creditSubtotal');
      }
    });
    return subtotal;
  }.property('lines', 'lines.@each', 'lines.@each.creditSubtotal', 'lines.@each.remove'),
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
    return this.get('user') && this.get('customer') && this.get('till') && this.get('quantity') > 0 && this.get('due') >= 0;
  }.property('user', 'till', 'customer', 'quantity', 'due'),
  nonCompletable: function() {
    return !this.get('completable');
  }.property('completable'),
  cashFmt: function(key, value) {
    if (value) {
      if (value.match(/\d+\.\d\d/)) {
        var cash = parseInt(Math.round(1000 * value * 100) / 1000);
        var cashSubtotal = this.get('cashSubtotal');
        var ratio = cash / cashSubtotal;
        if (ratio < 0) { ratio = 0; }
        if (ratio > 1) { ratio = 1; }
        this.set('ratio', 1 - ratio);
      }
    } else {
      return parseFloat(this.get('cash') * 0.01).toFixed(2);
    }
  }.property('cash'),
  creditFmt: function(key, value) {
    if (value) {
      if (value.match(/\d+\.\d\d/)) {
        var credit = parseInt(Math.round(1000 * value * 100) / 1000);
        var creditSubtotal = this.get('creditSubtotal');
        var ratio = credit / creditSubtotal;
        if (ratio < 0) { ratio = 0; }
        if (ratio > 1) { ratio = 1; }
        this.set('ratio', ratio);
      }
    } else {
      return parseFloat(this.get('credit') * 0.01).toFixed(2);
    }
  }.property('credit'),
  ratioChanged: function() {
    var ratio = this.get('ratio');
    var cashSubtotal = this.get('cashSubtotal');
    var creditSubtotal = this.get('creditSubtotal');
    var cashMultiplier = 0.0;
    var creditMultiplier = 0.0;
    if (ratio >= 0) {
      cashMultiplier = 1.0 - ratio;
      creditMultiplier = ratio;
    } else {
      cashMultiplier = ratio * -1.0;
      creditMultiplier = -1.0 - ratio;
    }
    this.set('cash', parseInt(Math.round(cashSubtotal * cashMultiplier)));
    this.set('credit', parseInt(Math.round(creditSubtotal * creditMultiplier)));
  }.observes('ratio', 'cashSubtotal', 'creditSubtotal')
});

SwapzPOS.Purchase.reopenClass({
  singular: 'purchase',
  plural: 'purchases'
});

SwapzPOS.Purchase.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.purchase, {
      sku: this.get('sku'),
      complete: this.get('complete'),
      flagged: this.get('flagged'),
      ratio: this.get('ratio'),
      note: this.get('note'),
      customer_id: null,
      till_id: null,
      store_id: null,
      user_id: null,
      lines_attributes: []
    });
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
        id: line.get('id'),
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
        _remove: line.get('_remove')
      };
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
      note: data.note
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
          certificate: _line.certificate,
          quantity: _line.quantity,
          note: _line.note,
          sku: _line.sku,
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