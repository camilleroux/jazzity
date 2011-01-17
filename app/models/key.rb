class Key < ActiveRecord::Base
  Letters = ['C' => 0, 'D' => 1, 'E' => 2, 'F' => 3, 'G' => 4, 'A' => 5, 'B' => 6]

  # Finds a key given a tonal index 0-11 and a letter index (to disambiguate enharmonic keys)
  def self.from_index(value, preferred_letter = nil)
    self.all.find {|k| k.index == value && (preferred_letter.nil? || k.letter_index == preferred_letter)}
  end

  # Finds a key object given the name (such as Eb)
  def self.from_name(value)
    self.all.find {|k| k.name == value}
  end

  # Finds a key object based on the name:
  # +Key['Eb']+
  # 
  def self.[](value)
    self.from_name(value) || self.from_index(value)
  end

  # Returns an array of the 12 primary keys (definitions around the cycle of fourths)
  def self.primaries
    self.find_all_by_primary(true)
  end

  def self.default
    self['C']
  end

  # Tests whether the current key is enharmonic with +another_key+.
  def enharmonic_with?(another_key)
    self.index == another_key.index
  end

end
