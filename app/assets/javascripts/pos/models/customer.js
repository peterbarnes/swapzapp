SwapzPOS.Customer = SwapzPOS.Base.extend({
  firstName: null,
  lastName: null,
  email: null,
  identifier: null,
  identifierType: null,
  organization: null,
  sku: null,
  notes: null,
  credit: 0,
  dateOfBirth: new Date(),
  addresses: null,
  phones: null,
  images: null,
  _selected: false,
  init: function() {
    this._super();
    this.set('credit', 0);
    this.set('addresses', Ember.A());
    this.set('phones', Ember.A());
    this.set('images', Ember.A());
  },
  fullname: function() {
    return this.get('firstName') + " " + this.get('lastName');
  }.property('firstName', 'lastName'),
  imagesSorted: function() {
    var images = this.get('images').toArray();
    images.sort(function(a, b) {
      return a['index'] - b['index'];
    });
    return images;
  }.property('images', 'images.@each', 'images.@each.index')
});

SwapzPOS.Customer.reopenClass({
  singular: 'customer',
  plural: 'customers'
});

SwapzPOS.Customer.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.customer, {
      first_name: this.get('firstName'),
      last_name: this.get('lastName'),
      email: this.get('email'),
      identifier: this.get('identifier'),
      identifier_type: this.get('identifierType'),
      organization: this.get('organization'),
      notes: this.get('notes'),
      date_of_birth: this.get('dateOfBirth').toISOString(),
      phone: this.get('phone'),
      addresses_attributes: [],
      phones_attributes: [],
      images_attributes: []
    });
    this.get('addresses').forEach(function(address) {
      var _address = {
        name: address.get('name'),
        _remove: address.get('_remove')
      }
      if (address.get('id')) {
        _address.id = address.get('id');
      }
      entity.customer.addresses_attributes.addObject(_address);
    });
    this.get('phones').forEach(function(phone) {
      var _phone = {
        name: phone.get('name'),
        number: phone.get('number'),
        _remove: phone.get('_remove')
      }
      if (phone.get('id')) {
        _phone.id = phone.get('id')
      }
      entity.customer.phones_attributes.addObject(_phone);
    });
    this.get('images').forEach(function(image) {
      var _image = {
        name: image.get('name'),
        description: image.get('description'),
        index: image.get('index'),
        __remove: image.get('_remove')
      }
      if (image.get('id')) {
        _image.id = image.get('id')
      }
      if (image.get('imageData')) {
        _image.image_data = image.get('imageData');
      } else if (image.get('imageUrl') && (/https?\:\/\/\w+((\:\d+)?\/\S*)?/).test(image.get('imageUrl'))) {
        _image.image_url = image.get('imageUrl');
      }
      entity.customer.images_attributes.addObject(_image);
    });
    return entity;
  },
  assign: function(data) {
    this._super(data);
    this.setProperties({
      firstName: data.first_name,
      lastName: data.last_name,
      email: data.email,
      identifier: data.identifier,
      identifierType: data.identifier_type,
      organization: data.organization,
      sku: data.sku,
      notes: data.notes,
      credit: data.credit,
      dateOfBirth: new Date(data.date_of_birth),
      imageUrl: data.image_url,
      phone: data.phone
    });
    if (data.sales) {
      var sales = [];
      data.sales.forEach(function(_sale){
        var sale = SwapzPOS.Sale.create();
        sale.assign(_sale);
        sales.addObject(sale);
      });
      this.set('sales', sales);
    }
    if (data.purchases) {
      var purchases = [];
      data.purchases.forEach(function(_purchase){
        var purchase = SwapzPOS.Purchase.create();
        purchase.assign(_purchase);
        purchases.addObject(purchase);
      });
      this.set('purchases', purchases);
    }
    if (data.repairs) {
      var repairs = [];
      data.repairs.forEach(function(_repair){
        var repair = SwapzPOS.Repair.create();
        repair.assign(_repair);
        repairs.addObject(repair);
      });
      this.set('repairs', repairs);
    }
    if (data.certificates) {
      var certificates = [];
      data.certificates.forEach(function(_certificate){
        var certificate = SwapzPOS.Certificate.create();
        certificate.assign(_certificate);
        certificates.addObject(certificate);
      });
      this.set('certificates', certificates);
    }
    if (data.images) {
      var images = [];
      data.images.forEach(function(_image){
        var image = SwapzPOS.Image.create({
          id: _image.id,
          name: _image.name,
          description: _image.description,
          index: _image.index,
          imageUrl: _image.image_url,
          createdAt: new Date(_image.created_at),
          updatedAt: new Date(_image.updated_at)
        });
        images.addObject(image);
      });
      this.set('images', images);
    }
    if (data.phones) {
      var phones = [];
      data.phones.forEach(function(_phone){
        var phone = SwapzPOS.Phone.create({
          id: _phone.id,
          name: _phone.name,
          number: _phone.number
        });
        phones.addObject(phone);
      });
      this.set('phones', phones);
    }
    if (data.addresses) {
      var addresses = [];
      data.addresses.forEach(function(_address){
        var address = SwapzPOS.Address.create({
          id: _address.id,
          city: _address.city,
          country: _address.country,
          firstLine: _address.first_line,
          name: _address.name,
          secondLine: _address.second_line,
          state: _address.state,
          zip: _address.zip
        });
        addresses.addObject(address);
      });
      this.set('addresses', addresses);
    }
    return this;
  }
});