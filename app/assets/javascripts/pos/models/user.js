SwapzPOS.User = SwapzPOS.Base.extend({
  active: false,
  administrator: false,
  authenticated: true,
  email: null,
  firstName: null,
  lastName: null,
  password: null,
  passwordConfirmation: null,
  username: null,
  pin: null,
  pinValue: null,
  gravatarUrl: null,
  tills: null,
  timecards: null,
  init: function() {
    this._super();
    this.set('tills', Ember.A());
    this.set('timecards', Ember.A());
  },
  fullname: function() {
    return this.get('firstName') + " " + this.get('lastName');
  }.property('firstName', 'lastName'),
  canCreateTransaction: function() {
    return this.get('tills.length') > 0;
  }.property('tills', 'tills.@each'),
  pinChanged: function() {
    if (this.get('pinValue') === this.get('pin')) {
      this.set('authenticated', true);
    } else {
      this.set('authenticated', false);
    }
  }.observes('pinValue'),
  removeTill: function(till) {
    this.get('tills').removeObject(till);
  },
  clockIn: function() {
    var timecard = SwapzPOS.Timecard.create({
      in: new Date(),
      user: this
    });
    timecard.save();
    this.get('timecards').insertAt(0, timecard);
  },
  clockOut: function() {
    var timecards = this.get('timecards');
    timecards.forEach(function(timecard) {
      if (timecard.get('isIn')) {
        timecard.set('out', new Date());
        timecard.save();
      }
    });
  },
  isClockedIn: function() {
    var timecards = this.get('timecards');
    var clockedIn = false;
    timecards.forEach(function(timecard) {
      if (timecard.get('isIn')) {
        clockedIn = true;
      }
    });
    return clockedIn;
  }.property('timecards.@each', 'timecards.@each.out', 'timecards.@each.in'),
  isClockedOut: function() {
    return !this.get('isClockedIn');
  }.property('timecards.@each', 'timecards.@each.out', 'timecards.@each.in'),
  currentTimecard: function() {
    var timecards = this.get('timecards');
    var _timecard = null;
    timecards.forEach(function(timecard) {
      if (timecard.get('isIn')) {
        _timecard = timecard;
      }
    });
    return _timecard;
  }.property('timecards.@each', 'timecards.@each.out', 'timecards.@each.in'),
  totalHours: function() {
    var timecards = this.get('timecards');
    var hours = 0;
    timecards.forEach(function(timecard) {
      hours += timecard.get('hours');
    });
    return hours;
  }.property('timecards', 'timecards.@each.hours')
});

SwapzPOS.User.reopenClass({
  singular: 'user',
  plural: 'users'
});

SwapzPOS.User.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.user, {
      active: this.get('active'),
      administrator: this.get('administrator'),
      email: this.get('email'),
      first_name: this.get('firstName'),
      last_name: this.get('lastName'),
      password: this.get('password'),
      password_confirmation: this.get('passwordConfirmation'),
      username: this.get('username'),
      pin: this.get('pin')
    });
    return entity;
  },
  assign: function(data) {
    this._super(data);
    this.setProperties({
      active: data.active,
      administrator: data.administrator,
      firstName: data.first_name,
      lastName: data.last_name,
      email: data.email,
      username: data.username,
      pin: data.pin,
      gravatarUrl: data.gravatar_url,
      tillId: data.till_id,
    });
    if (data.tills) {
      var user = this;
      var tills = [];
      data.tills.forEach(function(till) {
        var _till = SwapzPOS.Till.create();
        _till.assign(till, user);
        tills.addObject(_till);
      });
      this.set('tills', tills);
    }
    if (data.timecards) {
      var user = this;
      var timecards = [];
      data.timecards.forEach(function(timecard) {
        var _timecard = SwapzPOS.Timecard.create();
        _timecard.assign(timecard, user);
        timecards.addObject(_timecard);
      });
      this.set('timecards', timecards);
    }
    return this;
  }
});