SwapzPOS.Repair = SwapzPOS.Base.extend({
  complete: false,
  completedAt: null,
  flagged: false,
  note: null,
  identifier: null,
  identifierType: null,
  symptoms: null,
  sku: null,
  taxRate: null,
  completedAt: null,
  customer_id: null,
  customer: null,
  lines: null,
  location_id: null,
  location: null,
  payment: null,
  store_id: null,
  store: null,
  till_id: null,
  till: null,
  logs: null,
  user_id: null,
  user: null,
  images: null,
  init: function() {
    this._super();
    this.set('lines', Ember.A());
    this.set('logs', Ember.A());
    this.set('images', Ember.A());
    this.set('payment', SwapzPOS.Payment.create());
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
  }.property('lines', 'lines.@each', 'lines.@each.quantity', 'lines.@each.remove'),
  subtotal: function() {
    var lines = this.get('lines');
    var subtotal = 0;
    lines.forEach(function(line) {
      if (!line.get('_remove')) {
        subtotal += line.get('subtotal');
      }
    });
    return subtotal;
  }.property('lines', 'lines.@each.subtotal', 'lines.@each.remove'),
  taxableSubtotal: function() {
    var lines = this.get('lines');
    var subtotal = 0;
    lines.forEach(function(line) {
      if (line.get('taxable') &&  !line.get('_remove')) {
        subtotal += line.get('subtotal');
      }
    });
    return subtotal;
  }.property('taxRate', 'lines', 'lines.@each.subtotal', 'lines.@each.taxable', 'lines.@each.remove'),
  tax: function() {
    var taxableSubtotal = this.get('taxableSubtotal');
    if (taxableSubtotal > 0) {
      return parseInt(Math.round(taxableSubtotal * this.get('taxRate')));
    } else {
      return 0;
    }
  }.property('taxRate', 'lines', 'lines.@each.subtotal', 'lines.@each.taxable', 'lines.@each.remove'),
  total: function() {
    return this.get('subtotal') + this.get('tax');
  }.property('taxRate', 'lines', 'lines.@each.subtotal', 'lines.@each.taxable', 'lines.@each.remove'),
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
  status: function() {
    var logs = this.get('logs');
    if (logs.get('length') > 0) {
      var logsSorted = logs.toArray().sort(function(a,b) {
        return b.get('createdAt') - a.get('createdAt');
      });
      return logsSorted[0].get('name');
    }
    return null;
  }.property('logs', 'logs.@each', 'logs.@each.name'),
  saveable: function() {
    return !this.get('complete');
  }.property('complete'),
  nonSaveable: function() {
    return !this.get('saveable');
  }.property('saveable'),
  completable: function() {
    return !this.get('complete') && this.get('user') && this.get('till') && this.get('store') && this.get('payment') && this.get('quantity') > 0 && this.get('due') <= 0;
  }.property('complete', 'user', 'store', 'till', 'payment', 'quantity', 'due'),
  nonCompletable: function() {
    return !this.get('completable');
  }.property('completable')
});

SwapzPOS.Repair.reopenClass({
  singular: 'repair',
  plural: 'repairs'
});

SwapzPOS.Repair.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.repair, {
      complete: this.get('complete'),
      flagged: this.get('flagged'),
      note: this.get('note'),
      identifier: this.get('identifier'),
      identifier_type: this.get('identifierType'),
      symptoms: this.get('symptoms'),
      tax_rate: this.get('taxRate'),
      customer_id: this.get('customer_id'),
      lines_attributes: [],
      location_id: this.get('location_id'),
      logs_attributes: [],
      payment_attributes: null,
      user_id: this.get('user_id'),
      store_id: this.get('store_id'),
      till_id: this.get('till_id')
    });
    if (this.get('sku')) {
      entity.repair.sku = this.get('sku');
    }
    if (this.get('customer')) {
      entity.repair.customer_id = this.get('customer.id');
    }
    if (this.get('location')) {
      entity.repair.location_id = this.get('location.id');
    }
    if (this.get('user')) {
      entity.repair.user_id = this.get('user.id');
    }
    if (this.get('store')) {
      entity.repair.store_id = this.get('store.id');
    }
    if (this.get('till')) {
      entity.repair.till_id = this.get('till.id');
    }
    if (this.get('payment')) {
      entity.repair.payment_attributes = {
        cash: this.get('payment.cash'),
        credit: this.get('payment.credit'),
        check: this.get('payment.check'),
        gift_card: this.get('payment.giftCard'),
        store_credit: this.get('payment.storeCredit')
      }
      if (this.get('payment.id')) {
        entity.repair.payment_attributes.id = this.get('payment.id');
      }
    }
    this.get('logs').forEach(function(log) {
      var _log = {
        id: log.get('id'),
        name: log.get('name'),
        note: log.get('note'),
        user_id: log.get('user.id')
      };
      if (line.get('user')) {
        _log.user_id = log.get('user.id');
      }
      entity.repair.logs_attributes.addObject(_log);
    });
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
      entity.repair.lines_attributes.addObject(_line);
    });
    return entity;
  },
  assign: function(data) {
    this._super(data);
    this.setProperties({
      customer_id: data.customer_id,
      location_id: data.location_id,
      store_id: data.store_id,
      till_id: data.till_id,
      user_id: data.user_id,
      complete: data.complete,
      flagged: data.flagged,
      imageUrl: data.image_url,
      identifier: data.identifier,
      identifierType: data.identifier_type,
      note: data.note,
      symptoms: data.symptoms,
      sku: data.sku,
      taxRate: data.tax_rate
    });
    if (data.completed_at) {
      this.set('completedAt', new Date(data.completed_at));
    }
    if (data.customer) {
      this.set('customer', SwapzPOS.Customer.create().assign(data.customer));
    }
    if (data.location) {
      this.set('location', SwapzPOS.Location.create().assign(data.location));
    }
    if (data.user) {
      this.set('user', SwapzPOS.User.create().assign(data.user));
    }
    if (data.store) {
      this.set('store', SwapzPOS.Store.create().assign(data.store));
    }
    if (data.till) {
      this.set('till', SwapzPOS.Till.create().assign(data.till));
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
    if (data.images) {
      var images = [];
      data.images.forEach(function(_image){
        var image = SwapzPOS.Image.create({
          id: _image.id,
          name: _image.name,
          description: _image.description,
          index: _image.index,
          imageUrl: _image.image_url,
          createdAt: new Date(_image.created_at),
          updatedAt: new Date(_image.updated_at)
        });
        images.addObject(image);
      });
      this.set('images', images);
    }
    if (data.logs) {
      var logs = [];
      data.logs.forEach(function(_log){
        var log = SwapzPOS.Log.create({
          id: _log.id,
          name: _log.name,
          note: _log.note,
          createdAt: new Date(_log.created_at),
          updatedAt: new Date(_log.updated_at)
        });
        if (_log.user) {
          log.set('user', SwapzPOS.User.create().assign(_log.user));
        }
        logs.addObject(log);
      });
      this.set('logs', logs);
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