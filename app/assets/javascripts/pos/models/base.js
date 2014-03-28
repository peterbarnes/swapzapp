SwapzPOS.Base = Ember.Object.extend({
  id: null,
  createdAt: new Date(),
  updatedAt: new Date(),
  init: function() {
    this._super();
    this.set('createdAt', new Date());
    this.set('updatedAt', new Date());
  }
});

SwapzPOS.Base.reopenClass({
  meta: null,
  singular: '',
  plural: '',
  all: function(data) {
    var base = this;
    if (!base.meta) {
      var _meta = SwapzPOS.Meta.create();
      base.meta = _meta;
    } else {
      base.meta.setProperties({
        total: 0,
        page: 1,
        perPage: 10
      });
    }
    return new Ember.RSVP.Promise(function(resolve, reject) {
      $.ajax({
        url: SwapzPOS.get('API_URL') + base.plural,
        data: data
      }).then(function(response) {
        var results = [];
        if (response.meta) {
          var meta = response.meta;
          var _meta = base.meta;
          _meta.setProperties({
            total: meta.total,
            page: meta.page,
            perPage: meta.per_page
          });
        }
        if (response[base.plural]) {
          response[base.plural].forEach(function(object) {
            var resource = base.create();
            resource.assign(object);
            results.addObject(resource);
          });
        }
        resolve(results);
      }, function(error) {
        reject(error);
      });
    });
    return promise;
  },
  find: function(id, data) {
    var base = this;
    return new Ember.RSVP.Promise(function(resolve, reject) {
      $.ajax({
        url: SwapzPOS.get('API_URL') + base.plural + "/" + id,
        data: data
      }).then(function(response) {
        var _result = base.create();
        _result.assign(response[base.singular]);
        resolve(_result);
      }, function(error) {
        reject(error);
      });
    });
  }
});

SwapzPOS.Base.reopen({
  assign: function(data) {
    this.setProperties({
      id: data.id,
      createdAt: new Date(data.created_at),
      updatedAt: new Date(data.updated_at)
    });
  },
  entity: function() {
    var entity = {};
    entity[this.constructor.singular] = {
      
    }
    return entity;
  },
  serialize: function() {
    return this.entity();
  },
  save: function(callback) {
    var base = this;
    if (this.get('id')) {
      var url = SwapzPOS.get('API_URL') + base.constructor.plural + "/" + base.get('id');
      var type = 'PUT'
    } else {
      var url = SwapzPOS.get('API_URL') + base.constructor.plural;
      var type = 'POST'
    }
    $.ajax({
      url: url,
      data: base.serialize(),
      type: type,
      success: function(result) {
        if (result) {
          base.assign(result[base.constructor.singular]);
        } else {
          base.refresh();
        }
        if (callback) {
          callback();
        }
      },
      error: function (xhr, ajaxOptions, thrownError) {
        console.log(xhr);
        console.log(ajaxOptions);
        console.log(thrownError);
        if (callback) {
          callback(JSON.parse(xhr.responseText));
        }
      }
    });
  },
  refresh: function(callback) {
    var base = this;
    $.ajax({
      url: SwapzPOS.get('API_URL') + base.constructor.plural + "/" + base.get('id')
    }).then(function(response) {
      base.assign(response[base.constructor.singular]);
      if (callback) {
        callback();
      }
    });
  },
  delete: function() {
    var base = this;
    if (base.id) {
      $.ajax({
        url: SwapzPOS.get('API_URL') + base.constructor.plural + "/" + base.get('id'),
        type: 'DELETE'
      });
    }
  }
});