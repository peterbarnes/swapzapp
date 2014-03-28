SwapzPOS.PurchasesIndexController = Ember.ArrayController.extend({
  query: '',
  search: function() {
    var controller = this;
    SwapzPOS.Purchase.all({
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
      this.transitionToRoute('purchases.create');
    },
    edit: function(purchase) {
      this.transitionToRoute('purchase.edit', purchase.id);
    },
    view: function(purchase) {
      this.transitionToRoute('purchase', purchase.id);
    },
    print: function(purchase) {
      this.transitionToRoute('purchase.print', purchase.id);
    },
    paginate: function(page, per_page) {
      var controller = this;
      SwapzPOS.Purchase.all({
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