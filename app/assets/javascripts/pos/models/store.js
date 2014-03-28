SwapzPOS.Store = SwapzPOS.Base.extend({
  name: null,
  description: null,
  tills: null,
  image: null,
  init: function() {
    this._super();
    this.set('tills', Ember.A());
  }
});

SwapzPOS.Store.reopenClass({
  singular: 'store',
  plural: 'stores'
});

SwapzPOS.Store.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.store, {
      name: this.get('active'),
      description: this.get('amount')
    });
    return entity;
  },
  assign: function(data) {
    this._super(data);
    this.setProperties({
      name: data.name,
      description: data.description
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
    if (data.tills) {
      var tills = [];
      data.tills.forEach(function(till) {
        var _till = SwapzPOS.Till.create({
          id: till.id,
          name: till.name,
          minimum: till.minimum,
          taxRate: till.tax_rate,
          createdAt: new Date(till.created_at),
          updatedAt: new Date(till.updated_at)
        });
        tills.addObject(_till);
      });
      this.set('tills', tills);
    }
    return this;
  }
});