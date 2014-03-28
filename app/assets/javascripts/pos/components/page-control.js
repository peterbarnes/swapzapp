SwapzPOS.PageControlComponent = Ember.Component.extend({
  perPage: 10,
  page: 1,
  total: 0,
  update: function() {
    this.setProperties({
      total: this.get('model.meta.total'),
      page: this.get('model.meta.page'),
      perPage: this.get('model.meta.perPage')
    });
  }.observes('model.meta.total', 'model.meta.page', 'model.meta.perPage'),
  canPrev: function() {
    return this.get('page') > 1;
  }.property('page'),
  cantPrev: function() {
    return !(this.get('page') > 1);
  }.property('page'),
  canNext: function() {
    return this.get('page') <= Math.floor(this.get('total') / this.get('perPage'));
  }.property('page', 'perPage', 'total'),
  cantNext: function() {
    return !(this.get('page') <= Math.floor(this.get('total') / this.get('perPage')));
  }.property('page', 'perPage', 'total'),
  isTen: function() {
    return this.get('perPage') == 10;
  }.property('perPage'),
  isTwentyFive: function() {
    return this.get('perPage') == 25;
  }.property('perPage'),
  isFifty: function() {
    return this.get('perPage') == 50;
  }.property('perPage'),
  begin: function() {
    return ((this.get('page') - 1) * this.get('perPage')) + 1;
  }.property('page', 'perPage', 'total'),
  end: function() {
    var end = this.get('page') * this.get('perPage');
    if (end > this.get('total')) {
      end = this.get('total');
    }
    return end;
  }.property('page', 'perPage', 'total'),
  actions: {
    prev: function() {
      if (this.get('canPrev')) {
        this.decrementProperty('page');
        this.sendAction('paginate', this.get('page'), this.get('perPage'));
      }
    },
    next: function() {
      if (this.get('canNext')) {
        this.incrementProperty('page');
        this.sendAction('paginate', this.get('page'), this.get('perPage'));
      }
    },
    ten: function() {
      this.set('page', 1);
      this.set('perPage', 10);
      this.sendAction('paginate', this.get('page'), this.get('perPage'));
    },
    twentyfive: function() {
      this.set('page', 1);
      this.set('perPage', 25);
      this.sendAction('paginate', this.get('page'), this.get('perPage'));
    },
    fifty: function() {
      this.set('page', 1);
      this.set('perPage', 50);
      this.sendAction('paginate', this.get('page'), this.get('perPage'));
    }
  }
});