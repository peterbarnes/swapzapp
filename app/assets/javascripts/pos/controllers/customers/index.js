SwapzPOS.CustomersIndexController = Ember.ArrayController.extend({
  query: '',
  search: function() {
    var controller = this;
    SwapzPOS.Customer.all({
      search: this.get('query')
    }).then(function(content) {
      controller.set('content', content);
    });
  }.observes('query'),
  actions: {
    create: function() {
      this.transitionToRoute('customers.create');
    },
    edit: function(customer) {
      this.transitionToRoute('customer.edit', customer.id);
    },
    view: function(customer) {
      this.transitionToRoute('customer', customer.id);
    },
    print: function(customer) {
      this.transitionToRoute('customer.print', customer.id);
    },
    paginate: function(page, per_page) {
      var controller = this;
      SwapzPOS.Customer.all({
        search: this.get('query'), 
        page: page, 
        per_page: per_page
      }).then(function(content) {
        controller.set('content', content);
      });
    }
  }
});