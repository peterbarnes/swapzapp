SwapzPOS.Image = Ember.Object.extend({
  name: null,
  description: null,
  index: 0,
  imageData: null,
  imageUrl: null,
  createdAt: null,
  updatedAt: null,
  _remove: false,
  init: function() {
    this._super();
    this.set('createdAt', new Date());
    this.set('updatedAt', new Date());
  },
  imageSrc: function() {
    var imageData = this.get('imageData');
    var imageUrl = this.get('imageUrl');
    var imageSrc = '/assets/missing.png';
    
    if (imageData) {
      imageSrc = imageData;
    } else if (imageUrl) {
      imageSrc = imageUrl;
    }
    
    return imageSrc;
  }.property('imageData', 'imageUrl')
});