SwapzPOS.Unit = SwapzPOS.Base.extend({
  calculated: false,
  filing: 0,
  quantity: 0,
  name: null,
  sku: null,
  price: 0,
  taxable: true,
  item_id: null,
  item: null,
  components: null,
  conditions: null,
  variant: null,
  _selected: false,
  init: function() {
    this._super();
    this.set('components', Ember.A());
    this.set('conditions', Ember.A());
  },
  priceCalculated: function() {
    var unit = this;
    var item = this.get('item');
    if (item) {
      var calculated_price = item.get('price');
      item.get('components').forEach(function(component) {
        if (component.get('typical') && unit.get('components').indexOf(component) == -1) {
          calculated_price = calculated_price - component.adjuster(item.get('price'));
        }
        if (!component.get('typical') && unit.get('components').indexOf(component) >= 0) {
          calculated_price = calculated_price + component.adjuster(item.get('price'));
        }
      });
      item.get('conditions').forEach(function(condition) {
        calculated_price = calculated_price + condition.adjuster(item.get('price'));
      });
      var variant = this.get('variant');
      if (variant) {
        calculated_price = calculated_price + variant.adjuster(item.get('price'));
      }
      return calculated_price;
    } else {
      return 0;
    }
  }.property('item', 'components.@each', 'conditions.@each', 'variant')
});

SwapzPOS.Unit.reopenClass({
  singular: 'unit',
  plural: 'units'
});

SwapzPOS.Unit.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.unit, {
      item_id: this.get('item_id')
    });
    return entity;
  },
  assign: function(data) {
    this._super(data);
    this.setProperties({
      calculated: data.calculated,
      filing: data.filing,
      quantity: data.quantity,
      name: data.name,
      sku: data.sku,
      price: data.price,
      taxable: data.taxable,
      item_id: data.item_id
    });
    if (data.components) {
      var components = [];
      data.components.forEach(function(_component){
        var component = SwapzPOS.Component.create({
          id: _component.id,
          adjustment: _component.adjustment,
          adjustmentPercentage: _component.adjustment_percentage,
          adjustmentCash: _component.adjustment_cash,
          adjustmentCashPercentage: _component.adjustment_cash_percentage,
          adjustmentCredit: _component.adjustment_credit,
          adjustmentCreditPercentage: _component.adjustment_credit_percentage,
          description: _component.description,
          name: _component.name,
          typical: _component.typical,
          configured: _component.typical
        });
        components.addObject(component);
      });
      this.set('components', components);
    }
    if (data.conditions) {
      var conditions = [];
      data.conditions.forEach(function(_condition){
        var condition = SwapzPOS.Condition.create({
          id: _condition.id,
          adjustment: _condition.adjustment,
          adjustmentPercentage: _condition.adjustment_percentage,
          adjustmentCash: _condition.adjustment_cash,
          adjustmentCashPercentage: _condition.adjustment_cash_percentage,
          adjustmentCredit: _condition.adjustment_credit,
          adjustmentCreditPercentage: _condition.adjustment_credit_percentage,
          description: _condition.description,
          name: _condition.name
        });
        conditions.addObject(condition);
      });
      this.set('conditions', conditions);
    }
    if (data.variant) {
      this.set('variant', SwapzPOS.Variant.create({
        id: data.variant.id,
        adjustment: data.variant.adjustment,
        adjustmentPercentage: data.variant.adjustment_percentage,
        adjustmentCash: data.variant.adjustment_cash,
        adjustmentCashPercentage: data.variant.adjustment_cash_percentage,
        adjustmentCredit: data.variant.adjustment_credit,
        adjustmentCreditPercentage: data.variant.adjustment_credit_percentage,
        description: data.variant.description,
        identifier: data.variant.identifier,
        identifierType: data.variant.identifier_type,
        name: data.variant.name
      }));
    }
    if (data.item) {
      this.set('item', SwapzPOS.Item.create().assign(data.item));
    }
    return this;
  }
});