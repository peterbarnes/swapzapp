# Entry point and rake tasks for the Fakeout class

require 'fakeout'

namespace :fakeout do

  desc "clean away all data"
  task :clean, [:no_prompt] => :environment do |t, args|
    Fakeout.clean(args.no_prompt.nil?)
  end
  
  desc "fake out a tiny dataset"
  task :tiny => :clean do |t, args|
    Fakeout.new(:tiny).fakeout
  end

  desc "fake out a small dataset"
  task :small => :clean do |t, args|
    Fakeout.new(:small).fakeout
  end

  desc "fake out a medium dataset"
  task :medium => :clean do |t, args|
    Fakeout.new(:medium).fakeout
  end

  desc "fake out a large dataset"
  task :large => :clean do |t, args|
    Fakeout.new(:large).fakeout
  end
end