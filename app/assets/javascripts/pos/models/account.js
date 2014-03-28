SwapzPOS.Account = Ember.Object.extend({
  id: null,
  api_active: false,
  api_secret: null,
  namespace: null,
  title: null,
  token: null,
  createdAt: new Date(),
  updatedAt: new Date(),
  init: function() {
    this._super();
    this.set('createdAt', new Date());
    this.set('updatedAt', new Date());
  }
});