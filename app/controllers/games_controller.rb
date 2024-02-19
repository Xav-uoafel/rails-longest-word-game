class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = [] # Créer un tableau vide
    grid = ('a'..'z').to_a # Créer un tableau avec toutes les lettres de l'alphabet
    10.times { @letters << grid.sample } # Ajouter 10 lettres aléatoires dans le tableau
  end

  def included?(word, letters)
    # Vérifier si le mot est crée à partir des lettres
    word.chars.all? do |letter| # Vérifier chaque lettre du mot
      word.count(letter) <= letters.count(letter)
    end
  end

  def score
    @word = params[:word] # Voir les paramètres
    @letters = params[:letters].split(',') # Utiliser les lettres générées dans l'action new
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{@word}")
    @dictionary = JSON.parse(response.read)
    @result = if @dictionary['found'] == false # Vérifier si le mot est dans le dictionnaire
                { score: 0, message: 'not an English word' } # Verifier si le mot est en anglais
              elsif !included?(@word, @letters) # Utiliser la méthode included? pour vérifier la présence des lettres
                { score: 0, message: 'not in the grid' }
              else
                { score: @word.length, message: 'well done' } # Calculer le score
              end
  end
end
