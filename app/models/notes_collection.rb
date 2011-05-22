require "set"

class NotesCollection
  extend ActiveModel::Naming
	include Enumerable
	include KeyContext

	attr_accessor :keys
	attr_accessor :invalid_keys

	def initialize(value = [])
		@value_as_given = value
		@keys = []
		@invalid_keys = []
	
		value = value.split(/,| /).map(&:strip) if value.instance_of?(String)
		value.each do |key_name|
			key_object = Key[key_name]
		
			if key_object.nil?
				@invalid_keys << key_name
			else
				@keys << key_object
			end
		end
	end

  def to_s
    name
  end

  def name
    keys.join(", ")
  end

  def to_param
    keys.join(",")
  end

  def title
    if key
      "#{name} in #{key}"
    else
      name
    end
  end

  def notes
    keys.map(&:name)
  end

	class << self
	  def resolve(value)
	    collection = new(value)
	    if collection.invalid_keys.empty? and collection.keys.size > 1
	      collection
      else
        nil
      end
    end
    
		alias_method :[], :resolve
	end

	delegate :each, :to => :keys

	# Chords associated with this collection of notes
	def chords
		if key
			chords_in_key(key)
		else
			Key.primaries.map do |in_key|
				chords_in_key(in_key)
			end.flatten
		end.extend(ChordCollection)
	end

	private

	def chords_in_key(in_key)
		Chord.all.select do |c|
			c.tones.map(&:tone).to_set == keys.map {|k| (k.index - (in_key ? in_key.index : 0)) % 12 }.to_set
		end.map {|c| c.key = in_key; c}
	end

end
