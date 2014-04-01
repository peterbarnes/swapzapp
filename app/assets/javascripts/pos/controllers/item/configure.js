SwapzPOS.ItemConfigureController = Ember.ObjectController.extend({
  purchase: false,
  _components: [],
  _conditions: [],
  _variant: null,
  actions: {
    reset: function() {
      this.set('purchase', false);
      this.set('_components', Ember.A());
      this.set('_conditions', Ember.A());
      this.set('_variant', null);
    },
    addToCart: function() {
      var item = this.get('model');
      if (this.get('purchase')) {
        var line = SwapzPOS.Line.create({
          title: item.get('name'),
          amountCash: this.get('configuredCashPrice'),
          amountCredit: this.get('configuredCreditPrice'),
          quantity: 1,
          sku: item.get('sku'),
          taxable: item.get('taxable'),
          item: item
        });
        this.get('components').forEach(function(component) {
          line.bullets.addObject(component.name);
        });
        this.get('conditions').forEach(function(condition) {
          line.bullets.addObject(condition.name);
        });
        if (this.get('variant')) {
          line.bullets.addObject(this.get('variant.name'));
        }
        this.get('parent.lines').pushObject(line);
      } else {
        var line = SwapzPOS.Line.create({
          title: item.get('name'),
          amount: this.get('configuredPrice'),
          quantity: 1,
          sku: item.get('sku'),
          taxable: item.get('taxable'),
          item: item
        });
        this.get('components').forEach(function(component) {
          line.bullets.addObject(component.name);
        });
        this.get('conditions').forEach(function(condition) {
          line.bullets.addObject(condition.name);
        });
        if (this.get('variant')) {
          line.bullets.addObject(this.get('variant.name'));
        }
        this.get('parent.lines').pushObject(line);
      }
    },
    selectComponent: function(component) {
      if (this.get('_components').contains(component)) {
        this.get('_components').removeObject(component);
      } else {
        this.get('_components').pushObject(component);
      }
      component.set('_configured', !component.get('_configured'));
    },
    selectCondition: function(condition) {
      if (this.get('_conditions').contains(condition)) {
        this.get('_conditions').removeObject(condition);
      } else {
        this.get('_conditions').pushObject(condition);
      }
      condition.set('_configured', !condition.get('_configured'));
    },
    selectVariant: function(variant) {
      this.get('variants').forEach(function(variant) {
        variant.set('configured', false);
      });
      if (this.get('_variant') != variant) {
        variant.set('_configured', !variant.get('_configured'));
        this.set('_variant', variant);
      } else {
        this.set('_variant', null);
      }
    }
  },
  configuredCashPrice: function() {
    var controller = this;
    var item = this.get('model');
    if (item) {
      var item_price = item.get('priceCash');
      var calculated_price = item_price;
      item.get('components').forEach(function(component) {
        if (component.get('typical') && !controller.get('_components').contains(component)) {
          calculated_price = calculated_price - component.adjusterCash(item_price);
        }
        if (!component.get('typical') && controller.get('_components').contains(component)) {
          calculated_price = calculated_price + component.adjusterCash(item_price);
        }
      });
      controller.get('_conditions').forEach(function(condition) {
        calculated_price = calculated_price + condition.adjusterCash(item_price);
      });
      var variant = controller.get('_variant');
      if (variant) {
        calculated_price = calculated_price + variant.adjusterCash(item_price);
      }
      return calculated_price;
    } else {
      return 0;
    }
  }.property('model', '_components.@each', '_conditions.@each', '_variant'),
  configuredCreditPrice: function() {
    var controller = this;
    var item = this.get('model');
    if (item) {
      var item_price = item.get('priceCredit');
      var calculated_price = item_price;
      item.get('components').forEach(function(component) {
        if (component.get('typical') && !controller.get('_components').contains(component)) {
          calculated_price = calculated_price - component.adjusterCredit(item_price);
        }
        if (!component.get('typical') && controller.get('_components').contains(component)) {
          calculated_price = calculated_price + component.adjusterCredit(item_price);
        }
      });
      controller.get('_conditions').forEach(function(condition) {
        calculated_price = calculated_price + condition.adjusterCredit(item_price);
      });
      var variant = controller.get('_variant');
      if (variant) {
        calculated_price = calculated_price + variant.adjusterCredit(item_price);
      }
      return calculated_price;
    } else {
      return 0;
    }
  }.property('model', '_components.@each', '_conditions.@each', '_variant'),
  configuredPrice: function() {
    var controller = this;
    var item = this.get('model');
    if (item) {
      var item_price = item.get('price');
      var calculated_price = item_price;
      item.get('components').forEach(function(component) {
        if (component.get('typical') && !controller.get('_components').contains(component)) {
          calculated_price = calculated_price - component.adjuster(item_price);
        }
        if (!component.get('typical') && controller.get('_components').contains(component)) {
          calculated_price = calculated_price + component.adjuster(item_price);
        }
      });
      controller.get('_conditions').forEach(function(condition) {
        calculated_price = calculated_price + condition.adjuster(item_price);
      });
      var variant = controller.get('_variant');
      if (variant) {
        calculated_price = calculated_price + variant.adjuster(item_price);
      }
      return calculated_price;
    } else {
      return 0;
    }
  }.property('model', '_components.@each', '_conditions.@each', '_variant')
});