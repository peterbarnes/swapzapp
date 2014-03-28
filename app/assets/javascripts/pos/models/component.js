SwapzPOS.Component = Ember.Object.extend({
  id: null,
  adjustment: 0,
  adjustmentPercentage: false,
  adjustmentCash: 0,
  adjustmentCashPercentage: false,
  adjustmentCredit: 0,
  adjustmentCreditPercentage: false,
  description: null,
  name: null,
  typical: false,
  configured: false,
  adjuster: function(price) {
    if (this.get('adjustmentPercentage')) {
      return parseInt(Math.round(price * this.get('adjustment') * 0.01));
    } else {
      return parseInt(this.get('adjustment') * 100);
    }
  },
  adjusterCash: function(price) {
    if (this.get('adjustmentCashPercentage')) {
      return parseInt(Math.round(price * this.get('adjustmentCash') * 0.01));
    } else {
      return parseInt(this.get('adjustmentCash') * 100);
    }
  },
  adjusterCredit: function(price) {
    if (this.get('adjustmentCreditPercentage')) {
      return parseInt(Math.round(price * this.get('adjustmentCredit') * 0.01));
    } else {
      return parseInt(this.get('adjustmentCredit') * 100);
    }
  }
});