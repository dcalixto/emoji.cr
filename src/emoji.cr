require "./emoji/*"

module Emoji
  VERSION = "0.5.0"

  # Unicode range for emoji characters
  EMOJI_REGEX = /[\x{1f000}-\x{1ffff}\x{2049}-\x{3299}\x{a9}\x{2a}\x{ae}\x{fe0f}\x{203c}\x{200d}]+|[0-9#]\x{fe0f}\x{20e3}/

  enum RegexType
    Simple
    Generated
  end

  # Use class variable to store emoji map
  @@map = Emoji::EMOJI_MAP

  # Convert text emoji codes to Unicode emoji
  def self.emojize(text : String)
    text.scan(/:[^(:\s)]+?:/).map(&.[0])
      .uniq!
      .each do |name|
        code = @@map[name]?
        text = text.gsub(name, code) if code
      end
    text
  end

  # Remove emoji from text based on regex type
  def self.sanitize(text : String, regex : RegexType = :simple)
    case regex
    when .simple?
      text.gsub(EMOJI_REGEX, "")
    when .generated?
      text.gsub(GENERATED_EMOJI_REGEX, "")
    end
  end
end
