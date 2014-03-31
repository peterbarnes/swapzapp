SwapzPOS.SaleRoute = Ember.Route.extend({
  model: function(params) {
    return SwapzPOS.Sale.find(params.sale_id);
  }
});