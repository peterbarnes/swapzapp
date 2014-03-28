SwapzPOS.ImageGridComponent = Ember.Component.extend({
  classNames: ['image-grid'],
  columns: 1,
  columnSize: 12,
  columnClass: 'col-lg-3',
  update: function() {
    var columns = this.get('columns');
    var columnSize = 12 / columns;
    
    this.set('columnSize', columnSize);
    this.set('columnClass', 'col-lg-' + columnSize);
  }.observes('columns'),
  sliced: function() {
    var columns = this.get('columns');
    var images = this.get('images').toArray();
    var sliced = Ember.A();
    
    for (var i = 0, l = images.length; i < l; i += columns) {
      sliced.pushObject(images.slice(i, i + columns));
    }
    
    return sliced;
  }.property('images', 'images.@each', 'images.@each.index', 'columns'),
  actions: {
    remove: function(image) {
      this.sendAction('remove', image);
    },
    edit: function(image) {
      this.sendAction('edit', image);
    }
  }
});