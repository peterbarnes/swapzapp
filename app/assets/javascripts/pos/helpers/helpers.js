Ember.Handlebars.registerBoundHelper('currency', function(value) {
  if (isNaN(value)) { return "$0.00"; }
  return '$' + parseFloat(value / 100).toFixed(2).toString();
});

Ember.Handlebars.registerBoundHelper('boolean', function(value) {
  if (value) { return "Yes"; } else { return "No"; }
});

Ember.Handlebars.registerBoundHelper('truncate', function(str, len) {
  if (str && str.length > len) {
    return str.substring(0, len - 3) + '...';
  } else {
    return str;
  }
});

Ember.Handlebars.registerBoundHelper('now', function() {
  return new Date();
});

Ember.Handlebars.registerBoundHelper('format-date', function(date, format) {
  return moment(date).format(format);
});

Ember.Handlebars.registerBoundHelper('format-date-ago', function(date) {
  return moment(date).fromNow();
});

Ember.Handlebars.registerBoundHelper('round', function(number, precision) {
  return parseFloat(number).toFixed(precision);
});

Ember.Handlebars.helper('number-field', SwapzPOS.NumberField);
Ember.Handlebars.helper('currency-field', SwapzPOS.CurrencyField);
Ember.Handlebars.helper('range-field', SwapzPOS.RangeField);
Ember.Handlebars.helper('search-field', SwapzPOS.SearchField);