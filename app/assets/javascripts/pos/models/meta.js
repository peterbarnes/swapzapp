SwapzPOS.Meta = Ember.Object.extend({
  total: null,
  page: null,
  perPage: null,
  init: function() {
    this._super();
    this.set('total', 0);
    this.set('page', 1);
    this.set('perPage', 10);
  }
});