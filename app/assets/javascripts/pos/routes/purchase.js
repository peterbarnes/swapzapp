SwapzPOS.PurchaseRoute = Ember.Route.extend({
  model: function(params) {
    return SwapzPOS.Purchase.find(params.purchase_id, {addresses: true, phones: true});
  }
});