# frozen_string_literal: true

require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

spacer = "\n"
ruler = '-' * 50

print(
  "   -------------------------------------------------\n",
  "  |    Bienvenue sur 'ILS VEULENT TOUS MA POO' !    |\n",
  "  | Le but du jeu est d'être le dernier survivant ! |\n",
  "   -------------------------------------------------\n\n\n"
)

print("Quel est ton nom ?\n> ")
player_name = gets.chomp
player_name = 'Sanon' if player_name.empty?
print("Bonne chance, #{player_name}.\n\n")
print spacer + ruler + spacer

my_game = Game.new(player_name)

my_game.new_players_in_sight
while my_game.still_ongoing
  my_game.new_players_in_sight
  print spacer + ruler + spacer
  my_game.menu
  my_game.menu_choice
  print spacer + ruler + spacer
  my_game.show_players
  print spacer + ruler + spacer
  my_game.enemies_attack
  print spacer + ruler + spacer
end
my_game.end_game

binding.pry
