SwapzPOS.SalesIndexController = Ember.ArrayController.extend({
  query: '',
  search: function() {
    var controller = this;
    SwapzPOS.Sale.all({
      search: this.get('query'),
      user: true,
      store: true,
      customer: true,
      till: true,
      lines: true
    }).then(function(content) {
      controller.set('content', content);
    });
  }.observes('query'),
  actions: {
    create: function() {
      this.transitionToRoute('sales.create');
    },
    edit: function(sale) {
      this.transitionToRoute('sale.edit', sale.id);
    },
    view: function(sale) {
      this.transitionToRoute('sale', sale.id);
    },
    print: function(sale) {
      this.transitionToRoute('sale.print', sale.id);
    },
    paginate: function(page, per_page) {
      var controller = this;
      SwapzPOS.Sale.all({
        search: this.get('query'), 
        page: page, 
        per_page: per_page,
        user: true, 
        store: true, 
        customer: true, 
        till: true,
        lines: true
      }).then(function(content) {
        controller.set('content', content);
      });
    }
  }
});