SwapzPOS.CustomerUpdateController = Ember.ObjectController.extend({
  needs: ['imagesEdit', 'addressesEdit', 'phonesEdit'],
  actions: {
    save: function() {
      var customer = this.get('model');
      if (customer) {
        customer.save(function() {
          this.get('flash').success('Successfully saved customer!');
        }.bind(this));
      }
    },
    removeAddress: function(address) {
      address.set('_remove', !address.get('_remove'));
    },
    editAddress: function(address) {
      this.get('controllers.addressesEdit').set('model', address);
      this.get('controllers.addressesEdit').set('parent', this.get('model'));
      this.send('openModal', 'addresses.edit');
    },
    addAddress: function() {
      this.get('controllers.addressesEdit').set('model', SwapzPOS.Address.create());
      this.get('controllers.addressesEdit').set('parent', this.get('model'));
      this.send('openModal', 'addresses.edit');
    },
    removePhone: function(phone) {
      phone.set('_remove', !phone.get('_remove'));
    },
    editPhone: function(phone) {
      this.get('controllers.phonesEdit').set('model', phone);
      this.get('controllers.phonesEdit').set('parent', this.get('model'));
      this.send('openModal', 'phones.edit');
    },
    addPhone: function() {
      this.get('controllers.phonesEdit').set('model', SwapzPOS.Phone.create());
      this.get('controllers.phonesEdit').set('parent', this.get('model'));
      this.send('openModal', 'phones.edit');
    },
    removeImage: function(image) {
      image.set('_remove', !image.get('_remove'));
    },
    editImage: function(image) {
      this.get('controllers.imagesEdit').set('model', image);
      this.get('controllers.imagesEdit').set('parent', this.get('model'));
      this.send('openModal', 'images.edit');
    },
    addImage: function() {
      this.get('controllers.imagesEdit').set('model', SwapzPOS.Image.create());
      this.get('controllers.imagesEdit').set('parent', this.get('model'));
      this.send('openModal', 'images.edit');
    }
  }
});