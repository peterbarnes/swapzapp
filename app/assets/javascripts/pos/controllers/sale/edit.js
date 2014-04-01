SwapzPOS.SaleEditController = Ember.ObjectController.extend({
  needs: ['lineEdit', 'customerUpdate', 'itemConfigure', 'unitSelect'],
  tabs: [],
  certificateQuery: null,
  certificates: [],
  customers: [],
  customerQuery: null,
  items: [],
  itemQuery: null,
  unitQuery: null,
  init: function () {
    this._super();
    
    var tabs = Ember.A();
    var searchTab = SwapzPOS.Tab.create({
      name: 'Search',
      key: 'search',
      icon: 'fa fa-search',
      active: true
    });
    var cartTab = SwapzPOS.Tab.create({
      name: 'Cart',
      key: 'cart',
      icon: 'fa fa-shopping-cart',
      active: false
    });
    var customerTab = SwapzPOS.Tab.create({
      name: 'Customer',
      key: 'customer',
      icon: 'fa fa-group',
      active: false
    });
    var certificateTab = SwapzPOS.Tab.create({
      name: 'Gift Certificate',
      key: 'certificate',
      icon: 'fa fa-gift',
      active: false
    });
    var paymentTab = SwapzPOS.Tab.create({
      name: 'Payment',
      key: 'payment',
      icon: 'fa fa-dollar',
      active: false
    });
    var noteTab = SwapzPOS.Tab.create({
      name: 'Notes',
      key: 'note',
      icon: 'fa fa-book',
      active: false
    });
    tabs.addObject(searchTab);
    tabs.addObject(cartTab);
    tabs.addObject(customerTab);
    tabs.addObject(certificateTab);
    tabs.addObject(paymentTab);
    tabs.addObject(noteTab);
    
    this.set('tabs', tabs);
  },
  searchCertificates: function() {
    var query = this.get('certificateQuery');
    if (query) {
      var controller = this;
      SwapzPOS.Certificate.all({
        search: controller.get('certificateQuery'),
        customer: true,
        active: true
      }).then(function(content) {
        controller.set('certificates', content);
      });
    } else {
      this.set('certificates', Ember.A());
    }
  }.observes('certificateQuery'),
  searchCustomers: function() {
    var query = this.get('customerQuery');
    if (query) {
      var controller = this;
      SwapzPOS.Customer.all({
        search: controller.get('customerQuery'),
        phones: true,
        addresses: true
      }).then(function(content) {
        controller.set('customers', content);
      });
    } else {
      this.set('customers', Ember.A());
    }
  }.observes('customerQuery'),
  searchItems: function() {
    var query = this.get('itemQuery');
    if (query) {
      var controller = this;
      SwapzPOS.Item.all({
        search: controller.get('itemQuery')
      }).then(function(content) {
        controller.set('items', content);
      });
    } else {
      this.set('items', Ember.A());
    }
  }.observes('itemQuery'),
  actions: {
    reset: function() {
      this.set('certificates', Ember.A());
      this.set('customers', Ember.A());
      this.set('items', Ember.A());
      this.set('certificateQuery', null);
      this.set('customerQuery', null);
      this.set('itemQuery', null);
      this.set('unitQuery', null);
    },
    save: function() {
      var sale = this.get('model');
      sale.save(function() {
        this.get('flash').success('Successfully saved sale!');
      }.bind(this));
    },
    complete: function() {
      var sale = this.get('model');
      sale.set('complete', true);
      sale.save(function() {
        this.get('flash').success('Successfully completed purchase!');
      }.bind(this));
    },
    print: function() {
      this.transitionToRoute('sale.print', this.get('model.id'));
    },
    addUnit: function() {
      var query = this.get('unitQuery');
      if (query) {
        var controller = this;
        SwapzPOS.Unit.all({
          search: controller.get('unitQuery')
        }).then(function(content) {
          if (content.get('length') == 1) {
            controller.send('addUnitLine', content.get('firstObject'));
          } else {
            controller.get('controllers.unitSelect').set('content', content);
            controller.get('controllers.unitSelect').set('parent', controller);
            controller.send('openModal', 'unit.select');
          }
        });
        this.set('unitQuery', null);
      }
    },
    addUnitLine: function(unit) {
      controller = this;
      var line = SwapzPOS.Line.create({
        title: unit.get('name'),
        amount: unit.get('price'),
        quantity: 1,
        sku: unit.get('sku'),
        taxable: unit.get('taxable'),
        unit: unit
      });
      unit.get('components').forEach(function(component) {
        line.bullets.addObject(component.name);
      });
      unit.get('conditions').forEach(function(condition) {
        line.bullets.addObject(condition.name);
      });
      if (unit.get('variant')) {
        line.bullets.addObject(unit.get('variant.name'));
      }
      controller.get('model.lines').pushObject(line);
    },
    selectCertificate: function(certificate) {
      controller = this;
      certificate.refresh(function() {
        controller.set('certificate', certificate);
      });
    },
    removeCertificate: function(certificate) {
      var payment = this.get('model.payment');
      payment.set('giftCard', 0);
      this.set('certificate', null);
    },
    selectCustomer: function(customer) {
      controller = this;
      customer.refresh(function() {
        controller.set('customer', customer);
      });
    },
    editCustomer: function(customer) {
      this.get('controllers.customerUpdate').set('model', customer);
      this.get('controllers.customerUpdate').set('parent', this.get('model'));
      this.send('openModal', 'customer.update');
    },
    removeCustomer: function(customer) {
      var payment = this.get('model.payment');
      payment.set('storeCredit', 0);
      this.set('customer', null);
    },
    selectItem: function(item) {
      controller = this;
      item.refresh(function() {
        var typical_components = Ember.A();
        item.get('components').forEach(function(component) {
          if (component.get('typical')) {
            typical_components.addObject(component);
          }
        });
        controller.get('controllers.itemConfigure').send('reset');
        controller.get('controllers.itemConfigure').set('model', item);
        controller.get('controllers.itemConfigure').set('parent', controller.get('model'));
        controller.get('controllers.itemConfigure').set('_components', typical_components);
        controller.get('controllers.itemConfigure').set('purchase', false);
        controller.send('openModal', 'item.configure');
      });
    },
    editLine: function(line) {
      this.get('controllers.lineEdit').set('model', line);
      this.get('controllers.lineEdit').set('parent', this.get('model'));
      this.get('controllers.lineEdit').set('purchase', false);
      this.send('openModal', 'line.edit');
    },
    amountDue: function(field) {
      var sale = this.get('model');
      var payment = this.get('model.payment');
      payment.set(field, sale.get('due'));
    },
    increment: function(amount) {
      var payment = this.get('model.payment');
      payment.incrementProperty('cash', parseInt(amount));
    },
    available: function(field) {
      var sale = this.get('model');
      var payment = sale.get('payment');
      var subtotal = sale.get('subtotal');
      if (field == 'storeCredit') {
        var storeCredit = sale.get('customer.credit');
        if (subtotal > 0) {
          if (subtotal >= storeCredit) {
            payment.set('storeCredit', storeCredit);
          } else {
            payment.set('storeCredit', subtotal);
          }
        }
      }
      if (field == 'giftCard') {
        var balance = sale.get('certificate.balance');
        if (subtotal > 0) {
          if (subtotal >= balance) {
            payment.set('giftCard', balance);
          } else {
            payment.set('giftCard', subtotal);
          }
        }
      }
    },
    clear: function(field) {
      var payment = this.get('model.payment');
      payment.set(field, 0);
    }
  }
});