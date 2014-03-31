SwapzPOS.Item = SwapzPOS.Base.extend({
  description: null,
  identifier: null,
  identifierType: "UPC",
  manufacturer: null,
  name: null,
  price: 0,
  priceCash: 0,
  priceCredit: 0,
  saleable: false,
  sku: null,
  taxable: true,
  components: null,
  conditions: null,
  variants: null,
  images: null,
  _selected: false,
  init: function() {
    this._super();
    this.set('components', Ember.A());
    this.set('conditions', Ember.A());
    this.set('variants', Ember.A());
    this.set('images', Ember.A());
  },
  typicalComponents: function() {
    var _components = Ember.A();
    this.get('components').forEach(function(component) {
      if (component.get('typical')) {
        _components.pushObject(component);
      }
    });
    return _components;
  }.property('components')
});

SwapzPOS.Item.reopenClass({
  singular: 'item',
  plural: 'items'
});

SwapzPOS.Item.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.item, {
      
    });
    return entity;
  },
  assign: function(data) {
    this._super(data);
    this.setProperties({
      description: data.description,
      identifier: data.identifier,
      identifierType: data.identifier_type,
      imageUrl: data.image_url,
      manufacturer: data.manufacturer,
      name: data.name,
      price: data.price,
      priceCash: data.price_cash,
      priceCredit: data.price_credit,
      saleable: data.saleable,
      sku: data.sku,
      taxable: data.taxable
    });
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
    if (data.variants) {
      var variants = [];
      data.variants.forEach(function(_variant){
        var variant = SwapzPOS.Variant.create({
          id: _variant.id,
          adjustment: _variant.adjustment,
          adjustmentPercentage: _variant.adjustment_percentage,
          adjustmentCash: _variant.adjustment_cash,
          adjustmentCashPercentage: _variant.adjustment_cash_percentage,
          adjustmentCredit: _variant.adjustment_credit,
          adjustmentCreditPercentage: _variant.adjustment_credit_percentage,
          description: _variant.description,
          identifier: _variant.identifier,
          identifierType: _variant.identifier_type,
          name: _variant.name
        });
        variants.addObject(variant);
      });
      this.set('variants', variants);
    }
    return this;
  }
});