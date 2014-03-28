SwapzPOS.Message = Ember.Object.extend({
  body: null,
  date: null,
  user: null,
  init: function() {
    this._super();
    this.set('date', new Date());
    this.set('user', {});
  }
});