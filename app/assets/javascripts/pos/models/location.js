// attributes :id, :store_id, :description, :image_url, :name, :restock, :sku, :target, :created_at, :updated_at
// 
// has_one :store

SwapzPOS.Location = SwapzPOS.Base.extend({
  description: null,
  name: null,
  restock: null,
  sku: null,
  target: null,
  store: null,
  image: null,
  init: function() {
    this._super();
  }
});

SwapzPOS.Location.reopenClass({
  singular: 'location',
  plural: 'locations'
});

SwapzPOS.Location.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.location, {
      description: this.get('description'),
      name: this.get('name'),
      restock: this.get('restock'),
      sku: this.get('sku'),
      target: this.get('target'),
      store_id: null
    });
    if (this.get('store')) {
      entity.location.store_id = this.get('store.id');
    }
    return entity;
  },
  assign: function(data) {
    this._super(data);
    this.setProperties({
      description: data.description,
      name: data.name,
      restock: data.restock,
      sku: data.sku,
      target: data.target
    });
    if (data.image) {
      var _image = data.image;
      var image = SwapzPOS.Image.create({
        id: _image.id,
        name: _image.name,
        description: _image.description,
        index: _image.index,
        imageUrl: _image.image_url,
        createdAt: new Date(_image.created_at),
        updatedAt: new Date(_image.updated_at)
      });
      this.set('image', image);
    }
    if (data.store) {
      this.set('store', SwapzPOS.Store.create().assign(data.store));
    }
    return this;
  }
});