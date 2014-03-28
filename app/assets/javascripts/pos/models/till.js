SwapzPOS.Till = SwapzPOS.Base.extend({
  adjustments: null,
  name: null,
  taxRate: 0,
  minimum: 0,
  balance: 0,
  store: null,
  user: null,
  _selected: false,
  init: function() {
    this._super();
    this.set('adjustments', Ember.A());
  },
  assignUser: function(user) {
    this.set('user', user);
    this.save();
  },
  unassignUser: function() {
    this.set('user', null);
    this.save();
  }
});

SwapzPOS.Till.reopenClass({
  singular: 'till',
  plural: 'tills'
});

SwapzPOS.Till.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.till, {
      adjustments_attributes: [],
      name: this.get('name'),
      taxRate: this.get('taxRate'),
      minimum: this.get('minimum'),
      store_id: null,
      user_id: null
    });
    if (this.get('store')) {
      entity.till.store_id = this.get('store.id');
    }
    if (this.get('user')) {
      entity.till.user_id = this.get('user.id');
    }
    this.get('adjustments').forEach(function(adjustment) {
      var _adjustment = {
        amount: adjustment.get('amount'),
        balance: adjustment.get('balance'),
        description: adjustment.get('description'),
        title: adjustment.get('title'),
        user_id: adjustment.get('user.id')
      }
      entity.till.adjustments_attributes.push(_adjustment);
    });
    return entity;
  },
  assign: function(data, user) {
    this._super(data);
    this.setProperties({
      name: data.name,
      minimum: data.minimum,
      balance: data.balance,
      taxRate: data.tax_rate,
      adjustments: Ember.A(),
      store: null,
      user: null
    });
    if (data.adjustments) {
      var adjustments = [];
      data.adjustments.forEach(function(_adjustment){
        var adjustment = SwapzPOS.Adjustment.create({
          id: _adjustment.id,
          amount: _adjustment.amount,
          balance: _adjustment.balance,
          description: _adjustment.description,
          title: _adjustment.title,
          user: SwapzPOS.User.create().assign(_adjustment.user)
        });
        adjustments.addObject(adjustment);
      });
    }
    if (data.store) {
      this.set('store', SwapzPOS.Store.create().assign(data.store));
    }
    if (data.user) {
      this.set('user', SwapzPOS.User.create().assign(data.user));
      this.set('user.till', this);
    }
    if (user) {
      this.set('user', user);
    }
    return this;
  },
  metadata: function(callback) {
    var till = this;
    $.ajax({
      url: SwapzPOS.get('API_URL') + till.constructor.plural + "/" + till.get('id') + "/metadata"
    }).then(function(response) {
      if (callback) {
        callback(response[till.constructor.singular]);
      }
    });
  }
});