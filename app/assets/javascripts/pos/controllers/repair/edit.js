SwapzPOS.RepairEditController = Ember.ObjectController.extend({
  needs: ['lineEdit', 'customerUpdate', 'itemConfigure'],
  tabs: [],
  customers: [],
  customerQuery: null,
  customerPage: 0,
  itemQuery: null,
  itemPage: 0,
  items: [],
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
    var symptomTab = SwapzPOS.Tab.create({
      name: 'Symptoms',
      key: 'symptom',
      icon: 'fa fa-bug',
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
    tabs.addObject(symptomTab);
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
        if (content.get('length') > 0) {
          controller.set('customerPage', 1);
        }
      });
    } else {
      this.set('customers', Ember.A());
      this.set('customerPage', 0);
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
        if (content.get('length') > 0) {
          controller.set('itemPage', 1);
        }
      });
    } else {
      this.set('items', Ember.A());
      this.set('page', 0);
    }
  }.observes('itemQuery'),
  cantMoreCustomers: function() {
    return this.get('customerPage') < 1;
  }.property('customerPage'),
  cantMoreItems: function() {
    return this.get('itemPage') < 1;
  }.property('itemPage'),
  actions: {
    reset: function() {
      this.set('customers', Ember.A());
      this.set('items', Ember.A());
      this.set('customerQuery', null);
      this.set('itemQuery', null);
      this.set('customerPage', 0);
      this.set('itemPage', 0);
    },
    save: function() {
      var repair = this.get('model');
      repair.save(function() {
        this.get('flash').success('Successfully saved repair!');
      }.bind(this));
    },
    complete: function() {
      var repair = this.get('model');
      repair.set('complete', true);
      repair.save(function() {
        this.get('flash').success('Successfully completed repair!');
      }.bind(this));
    },
    print: function() {
      this.transitionToRoute('repair.print', this.get('model.id'));
    },
    moreCustomers: function() {
      this.incrementProperty('customerPage');
      var controller = this;
      SwapzPOS.Customer.all({
        search: controller.get('customerQuery'),
        phones: true,
        addresses: true,
        page: this.get('customerPage')
      }).then(function(content) {
        controller.get('customers').addObjects(content);
      });
    },
    moreItems: function() {
      this.incrementProperty('itemPage');
      var controller = this;
      SwapzPOS.Item.all({
        search: controller.get('itemQuery'),
        page: this.get('itemPage')
      }).then(function(content) {
        controller.get('items').addObjects(content);
      });
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
      var repair = this.get('model');
      var payment = this.get('model.payment');
      payment.set(field, repair.get('due'));
    },
    increment: function(amount) {
      var payment = this.get('model.payment');
      payment.incrementProperty('cash', parseInt(amount));
    },
    clear: function(field) {
      var payment = this.get('model.payment');
      payment.set(field, 0);
    },
    clearQuery: function(property) {
      this.set(property, null);
    }
  }
});