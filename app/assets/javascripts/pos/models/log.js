SwapzPOS.Log = Ember.Object.extend({
  name: null,
  note: null,
  createdAt: null,
  updatedAt: null,
  user_id: null,
  user: null,
  init: function() {
    this._super();
    this.set('createdAt', new Date());
    this.set('updatedAt', new Date());
  }
});