SwapzPOS.ImagesEditController = Ember.ObjectController.extend({
  parent: null,
  data: null,
  url: null,
  updateData: function() {
    this.set('model.imageData', this.get('data'));
  }.observes('data'),
  updateUrl: function() {
    this.set('model.imageUrl', this.get('url'));
  }.observes('url'),
  actions: {
    done: function() {
      var parent = this.get('parent');
      parent.get('images').addObject(this.get('model'));
    }
  }
});