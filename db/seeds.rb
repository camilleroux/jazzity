# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


### CLEAR EXISTING JAZZ MODEL TABLE ###
%w(
  meters
  forms
  vehicles
  tunes
  tune_progressions
  tune_concepts
  instruments
  musicians
  progressions
  progression_components
  concepts
  chord_qualities
  chord_scales
  chord_symbols
  chord_tones
  chords
  modes
  scale_tones
  scales
  voicing_tones
  voicings
).each do |table|
  ActiveRecord::Base.connection.execute "TRUNCATE TABLE `#{table}`"
end

%w(
  meters
  forms
  vehicles
  instruments
  musicians
  concepts
  scales
  chords
  voicings
  progressions
  tunes
).each {|f| require Rails.root.join("db/seeds/#{f}.rb") }

Searchable.regenerate_all
