SwapzPOS.SalePrintController = Ember.ObjectController.extend({
  templates: [],
  template: null,
  templatePath: function() {
    var template = this.get('template');
    var sale = this.get('model');
    var id = sale.get('id');
    if (id) {
      var path = '/operation/sales/' + sale.get('id') + '/template/';
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