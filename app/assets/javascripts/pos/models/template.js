SwapzPOS.Template = SwapzPOS.Base.extend({
  name: null,
  category: null,
  body: null,
  primary: false
});

SwapzPOS.Template.reopenClass({
  singular: 'template',
  plural: 'templates'
});

SwapzPOS.Template.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.template, {
      name: this.get('name'),
      category: this.get('category'),
      body: this.get('body'),
      primary: this.get('primary')
    });
    return entity;
  },
  assign: function(data) {
    this._super(data);
    this.setProperties({
      name: data.name,
      category: data.category,
      body: data.body,
      primary: data.primary
    });
    return this;
  }
});