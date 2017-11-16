class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(letter)
    raise ArgumentError unless letter =~ /\w/
    letter.downcase!
    collection = (@word.include?(letter) ? @guesses : @wrong_guesses)
    return false if collection.include?(letter)
    collection << letter
    true
  end

  def word_with_guesses
    guessed_letters = ''
    @word.chars do |letter|
      guessed_letters << (@guesses.include?(letter) ? letter : '-')
    end
    guessed_letters
  end

  def check_win_or_lose
    if @wrong_guesses.size > 6
      :lose
    else
      @guesses.chars.sort == @word.chars.uniq.sort ? :win : :play
    end
  end

end
