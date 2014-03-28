SwapzPOS.CustomerRoute = Ember.Route.extend({
  model: function(params) {
    return SwapzPOS.Customer.find(params.customer_id, {certificates: true, sales: true, purchases: true, repairs: true});
  }
});