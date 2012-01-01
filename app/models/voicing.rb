class Voicing < ActiveRecord::Base
  extend FriendlyId
  
  include KeyContext
  include OctaveContext
  include Commentable
  include Resourceable

  acts_as_tree
  friendly_id :name, :use => :scoped, :scope => :chord

  belongs_to :voicing_family
  belongs_to :chord
  has_many :tones, :class_name => 'VoicingTone', :extend => Tones
  has_many :voice_leadings_to, :class_name => "VoiceLeading", :foreign_key => "to_voicing_id"
  has_many :voice_leadings_from, :class_name => "VoiceLeading", :foreign_key => "from_voicing_id"
  belongs_to :upper_structure_chord, :class_name => "Chord"

  delegate :notes, :to => :tones
  delegate :octavized_notes, :to => :tones

  validates :name, :presence => true

  def to_s
    name
  end

  def title
    if key
      "#{name} Voicing in #{key}"
    else
      "#{name} Voicing"
    end
  end

  def chord_in_key
    chord.in_key_of(key)
  end

  def specify_tones=(values)
    tones.specify(values)
  end

  def self.resolve(name)
    find_by_name(name)
  end

  class << self
    alias_method :[], :resolve
  end

  def to_json(options = {})
    super({:methods => [:notes]}.merge(options))
  end
end

