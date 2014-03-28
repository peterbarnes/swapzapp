SwapzPOS.CustomerPrintController = Ember.ObjectController.extend({
  templates: [],
  template: null,
  templatePath: function() {
    var template = this.get('template');
    var customer = this.get('model');
    var id = customer.get('id');
    if (id) {
      var path = '/operation/customers/' + customer.get('id') + '/template/';
      if (template) {
        path += '?template=' + this.get('template.id');
      }
      return path;
    }
    return null;
  }.property('model.id', 'template'),
  actions: {
    print: function() {
      _window = window.open(this.get('templatePath'));
      _window.focus();
      _window.print();
    }
  }
});