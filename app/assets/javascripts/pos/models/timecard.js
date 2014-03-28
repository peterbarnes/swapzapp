SwapzPOS.Timecard = SwapzPOS.Base.extend({
  flagged: false,
  in: new Date(),
  note: null,
  out: null,
  user: null,
  now: new Date(),
  init: function() {
    this._super();
    this.tick();
  },
  tick: function() {
    var now = new Date()

    this.setProperties({
      now: now
    });

    var self = this;
    setTimeout(function(){ self.tick(); }, 5000)
  },
  hours: function() {
    var _in = moment(this.get('in'));
    if (this.get('out')) {
      var _out = moment(this.get('out'));
    } else {
      var _out = moment(new Date());
    }
    return _out.diff(_in, 'hours', true);
  }.property('in', 'out', 'now'),
  isIn: function() {
    return this.get('out') === null;
  }.property('in', 'out'),
  isOut: function() {
    return this.get('out') !== null;
  }.property('in', 'out'),
  flag: function(note) {
    this.set('flagged', true);
    this.set('note', note);
    this.save();
  }
});

SwapzPOS.Timecard.reopenClass({
  singular: 'timecard',
  plural: 'timecards'
});

SwapzPOS.Timecard.reopen({
  entity: function() {
    var entity = this._super();
    $.extend(entity.timecard, {
      flagged: this.get('flagged'),
      in: this.get('in').toISOString(),
      note: this.get('note'),
      out: null,
      user_id: null
    });
    if (this.get('out')) {
      entity.timecard.out = this.get('out').toISOString();
    }
    if (this.get('user')) {
      entity.timecard.user_id = this.get('user.id');
    }
    return entity;
  },
  assign: function(data, user) {
    this._super(data);
    this.setProperties({
      flagged: data.flagged,
      in: new Date(data.in),
      note: data.note
    });
    if (data.out) {
      this.set('out', new Date(data.out));
    }
    if (data.user) {
      this.set('user', SwapzPOS.User.create().assign(data.user));
    }
    if (user) {
      this.set('user', user);
    }
    return this;
  }
});