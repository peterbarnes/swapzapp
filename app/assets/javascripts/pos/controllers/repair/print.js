SwapzPOS.RepairPrintController = Ember.ObjectController.extend({
  templates: [],
  template: null,
  templatePath: function() {
    var template = this.get('template');
    var repair = this.get('model');
    var id = repair.get('id');
    if (id) {
      var path = '/operation/repairs/' + repair.get('id') + '/template/';
      if (template) {
        path += '?template=' + this.get('template.id');
      }
      return path;
    }
    return null;
  }.property('model.id', 'template'),
  primary: function() {
    var controller = this;
    var templates = this.get('templates');
    templates.forEach(function(template) {
      if (template.get('primary')) {
        controller.set('template', template);
      }
    });
  }.observes('templates', 'templates.@each'),
  actions: {
    print: function() {
      _window = window.open(this.get('templatePath'));
      _window.focus();
      _window.print();
    }
  }
});