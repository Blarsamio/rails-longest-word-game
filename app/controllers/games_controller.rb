require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters]
    @result = run_game(@word, @letters)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.parse("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def run_game(word, letters)
    if included?(word, letters)
      if english_word?(word)
        "Congratulations! #{word} is a valid English word!"
      else
        "Sorry but #{word} does not seem to be a valid English word..."
      end
    else
      "Sorry but #{word} can't be built out of #{letters}"
    end
  end
end
