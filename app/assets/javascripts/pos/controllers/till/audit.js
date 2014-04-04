SwapzPOS.TillAuditController = Ember.ObjectController.extend({
  description: null,
  pennies: 0,
  nickels: 0,
  dimes: 0,
  quarters: 0,
  ones: 0,
  fives: 0,
  tens: 0,
  twenties: 0,
  fifties: 0,
  hundreds: 0,
  total: 0,
  penniesSum: function() {
    return this.get('pennies');
  }.property('pennies'),
  nickelsSum: function() {
    return this.get('nickels') * 5;
  }.property('nickels'),
  dimesSum: function() {
    return this.get('dimes') * 10;
  }.property('dimes'),
  quartersSum: function() {
    return this.get('quarters') * 25;
  }.property('quarters'),
  onesSum: function() {
    return this.get('ones') * 100;
  }.property('ones'),
  fivesSum: function() {
    return this.get('fives') * 500;
  }.property('fives'),
  tensSum: function() {
    return this.get('tens') * 1000;
  }.property('tens'),
  twentiesSum: function() {
    return this.get('twenties') * 2000;
  }.property('twenties'),
  fiftiesSum: function() {
    return this.get('fifties') * 5000;
  }.property('fifties'),
  hundredsSum: function() {
    return this.get('hundreds') * 10000;
  }.property('hundreds'),
  sum: function() {
    var pennies = parseInt(this.get('penniesSum'));
    var nickels = parseInt(this.get('nickelsSum'));
    var dimes = parseInt(this.get('dimesSum'));
    var quarters = parseInt(this.get('quartersSum'));
    var ones = parseInt(this.get('onesSum'));
    var fives = parseInt(this.get('fivesSum'));
    var tens = parseInt(this.get('tensSum'));
    var twenties = parseInt(this.get('twentiesSum'));
    var fifties = parseInt(this.get('fiftiesSum'));
    var hundreds = parseInt(this.get('hundredsSum'));
    
    this.set('total', pennies + nickels + dimes + quarters + ones + fives + tens + twenties + fifties + hundreds);
  }.observes('pennies', 'nickels', 'dimes', 'quarters', 'ones', 'fives', 'tens', 'twenties', 'fifties', 'hundreds'),
  difference: function() {
    var till = this.get('model');
    return this.get('total') - till.get('balance');
  }.property('total'),
  actions: {
    audit: function() {
      var date = new Date();
      var total = this.get('total');
      var till = this.get('model');
      var adjustment = SwapzPOS.Adjustment.create();
      adjustment.set('amount', this.get('difference'));
      adjustment.set('balance', till.get('balance'));
      adjustment.set('user', till.get('user'));
      adjustment.set('description', this.get('description'));
      adjustment.set('title', "Audit " + date + "(" + till.get('user.fullname') + ")");
      till.get('adjustments').push(adjustment);
      till.save();
    },
    plus: function(property) {
      this.incrementProperty(property);
    },
    minus: function(property) {
      if (this.get(property) > 0) {
        this.decrementProperty(property);
      }
    },
    reset: function() {
      this.set('description', null);
      this.set('pennies', 0);
      this.set('nickels', 0);
      this.set('dimes', 0);
      this.set('quarters', 0);
      this.set('ones', 0);
      this.set('fives', 0);
      this.set('tens', 0);
      this.set('twenties', 0);
      this.set('fifties', 0);
      this.set('hundreds', 0);
      this.set('total', 0);
    }
  }
});