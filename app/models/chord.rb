class Chord < ActiveRecord::Base
  extend FriendlyId
  include KeyContext
  include Commentable
  include Searchable::Model
  
  acts_as_tree
  friendly_id :name, :use => :slugged
  
  belongs_to :chord_quality

  has_many :symbols, :class_name => 'ChordSymbol'
  has_one :primary_symbol, :class_name => 'ChordSymbol', :conditions => {:primary => true}

  has_many :chord_scales
  has_many :modes, :through => :chord_scales
  has_many :tones, :class_name => 'ChordTone', :extend => Tones
  has_many :voicings

  delegate :notes, :to => :tones
  delegate :octavized_notes, :to => :tones
  delegate :intervals, :to => :tones
  delegate :step_names, :to => :tones
  delegate :interval_names, :to => :tones

  validates :name, :presence => true
  validates :chord_quality, :presence => true

  define_searchables do
    searchables.create(:name => "#{name} Chord")

    symbols.each {|symbol| searchables.create(:name => "#{symbol} Chord") }

    Key.primaries.each do |key|
      searchables.create(:name => "#{key.name} #{name} Chord", :key_name => key.name)
      symbols.each {|symbol| searchables.create(:name => "#{key.name}#{symbol} Chord", :key_name => key.name) }

      in_key_of(key).tap do |chord|
        searchables.create(:name => chord.notes.join(", "), :display_name => "#{chord.notes.join(', ')} (#{title})", :key_name => key.name, :priority => 2)
      end
    end
  
    modes.each(&:generate_searchables)
  end

  def to_s
    name
  end

  def short_name
    "#{key}#{primary_symbol}"
  end

  def title
    if key
      "#{key} #{name}"
    else
      name
    end
  end

  def staff_notes
    octavized_notes
  end

  def symbols_list
    symbols.map {|s| key.to_s + s.name }.join(', ')
  end

  # Resolves a chord symbol into a chord.
  # Implementation is somewhat flakey due to the potential ambiguities arising 
  # from specifying key and symbols together.
  def self.resolve(symbol)
    in_key = nil
  
    return nil if symbol.nil?
    symbol = symbol.dup
  
    symbol.gsub!(/ Chord/i, "")
  
    Key.all.each do |k|
      if symbol.starts_with?(k.name)
        in_key = k
        symbol.sub!(k.name, '').strip
        break
      end
    end
  
    chord_symbol = ChordSymbol[symbol]
  
    # Perhaps the matched key was really part of the name of the chord, try that:
    if chord_symbol.nil? && !in_key.nil?
      symbol = in_key.name + symbol
      chord_symbol = ChordSymbol[symbol]
    end
  
    # If still not found, must be invalid:
    return nil if chord_symbol.nil?
  
    chord = chord_symbol.chord
    chord.key = in_key unless in_key.nil?
    chord
  end

  class << self
    alias_method :[], :resolve
  end

  def to_json(options = {})
    super({:methods => [:notes]}.merge(options))
  end

end
