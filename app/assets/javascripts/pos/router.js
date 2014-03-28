SwapzPOS.Router.reopen({
  rootURL: '/pos/'
});

SwapzPOS.Router.map(function() {
  this.route('home');
  this.route('profile');
  this.resource('sales', { path: "/sales" }, function() {
    this.route('create', { path: "/create" });
  });
  this.resource('sale', { path: "/sales/:sale_id" }, function() {
    this.route('edit', { path: "/edit" });
    this.route('print', { path: "/print" });
  });
  this.resource('purchases', { path: "/purchases" }, function() {
    this.route('create', { path: "/create" });
  });
  this.resource('purchase', { path: "/purchases/:purchase_id" }, function() {
    this.route('edit', { path: "/edit" });
    this.route('print', { path: "/print" });
  });
  this.resource('repairs', { path: "/repairs" }, function() {
    this.route('create', { path: "/create" });
  });
  this.resource('repair', { path: "/repairs/:repair_id" }, function() {
    this.route('edit', { path: "/edit" });
    this.route('print', { path: "/print" });
  });
  this.resource('customers', { path: "/customers" }, function() {
    this.route('create', { path: "/create" });
  });
  this.resource('customer', { path: "/customers/:customer_id" }, function() {
    this.route('edit', { path: "/edit" });
    this.route('print', { path: "/print" });
  });
});