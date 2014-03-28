SwapzPOS.SaleEditController = Ember.ObjectController.extend({
  needs: ['lineEdit', 'customerUpdate'],
  tabs: [],
  customers: [],
  customerQuery: null,
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
    tabs.addObject(paymentTab);
    tabs.addObject(noteTab);
    
    this.set('tabs', tabs);
  },
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
  actions: {
    save: function() {
      var sale = this.get('model');
      sale.save();
    },
    complete: function() {
      var sale = this.get('model');
      sale.set('complete', true);
      sale.save();
    },
    createCustomer: function() {
      this.get('controllers.customerUpdate').set('model', SwapzPOS.Customer.create());
      this.get('controllers.customerUpdate').set('parent', this.get('model'));
      this.send('openModal', 'customer.update');
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
      this.set('customer', null);
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
    available: function() {
      var sale = this.get('model');
      var payment = sale.get('payment');
      var subtotal = sale.get('subtotal');
      var storeCredit = sale.get('customer.credit');
      if (subtotal > 0) {
        if (subtotal >= storeCredit) {
          payment.set('storeCredit', storeCredit);
        } else {
          payment.set('storeCredit', subtotal);
        }
      }
    },
    clear: function(field) {
      var payment = this.get('model.payment');
      payment.set(field, 0);
    }
  }
});