SwapzPOS.SaleEditController = Ember.ObjectController.extend({
  needs: ['lineEdit', 'customerUpdate', 'itemConfigure'],
  tabs: [],
  certificateQuery: null,
  certificates: [],
  customers: [],
  customerQuery: null,
  items: [],
  itemQuery: null,
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
    save: function() {
      var sale = this.get('model');
      sale.save();
    },
    complete: function() {
      var sale = this.get('model');
      sale.set('complete', true);
      sale.save();
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
        controller.get('controllers.itemConfigure').set('model', item);
        controller.get('controllers.itemConfigure').set('parent', controller.get('model'));
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