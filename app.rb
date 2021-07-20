# frozen_string_literal: true

require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

npc1 = Player.new('Josiane Bellgoss')
npc2 = Player.new('José Bellikeu')

statement = "Voici l’état de chaque joueurs:\n"
spacer = "\n"
ruler = '-' * 40

print statement
npc1.show_state
npc2.show_state
print spacer + ruler + spacer

while npc1.status.include?('En vie') && npc2.status.include?('En vie')
  # Proceed the combat while both are alive
  print("Passons à la phase d’attaque:\n")
  npc1.attacks(npc2)

  # We replace 'break' with 'unless' to get the states at the end of the loop
  npc2.attacks(npc1) unless npc2.status.include? 'Mort'

  print spacer
  print statement
  npc1.show_state
  npc2.show_state

  print spacer + ruler + spacer
end

# binding.pry
