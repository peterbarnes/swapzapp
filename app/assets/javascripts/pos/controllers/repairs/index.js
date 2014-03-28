SwapzPOS.RepairsIndexController = Ember.ArrayController.extend({
  query: '',
  firstObject: Ember.computed.alias('content.firstObject'),
  search: function() {
    var controller = this;
    SwapzPOS.Repair.all({
      search: this.get('query'), 
      customer: true,
      location: true,
      store: true,
      till: true,
      logs: true,
      lines: true
    }).then(function(content) {
      controller.set('content', content);
    });
  }.observes('query'),
  actions: {
    create: function() {
      this.transitionToRoute('repairs.create');
    },
    edit: function(repair) {
      this.transitionToRoute('repair.edit', repair.id);
    },
    view: function(repair) {
      this.transitionToRoute('repair', repair.id);
    },
    flag: function(repair) {
      repair.set('flagged', !repair.get('flagged'));
      repair.save();
    },
    print: function(repair) {
      this.transitionToRoute('repair.print', repair.id);
    },
    paginate: function(page, per_page) {
      var controller = this;
      SwapzPOS.Repair.all({
        search: this.get('query'),
        page: page, 
        per_page: per_page,
        customer: true,
        location: true,
        store: true,
        till: true,
        logs: true,
        lines: true
      }).then(function(content) {
        controller.set('content', content);
      });
    }
  }
});