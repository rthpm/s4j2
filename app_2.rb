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
print("Bonne chance, #{player_name}.\n\n")
print spacer + ruler + spacer

player = HumanPlayer.new(player_name)
npc1 = Player.new('Josiane Bellgoss')
npc2 = Player.new('José Bellikeu')
ennemies = [npc1, npc2]

while player.status.include?('En vie') && (npc1.status.include?('En vie') || npc2.status.include?('En vie'))
  # Proceed the combat while anyone is still are alive
  print("Passons à la phase d’attaque:\n")

  print spacer

  # Trying something, dunno if it’s good practice
  menu = <<~EOT
    Quelle action veux-tu effectuer ?
        a - chercher une meilleure arme
        s - chercher à se soigner
    Ou préfères-tu attaquer un ennemi ?
  EOT

  print menu
  ennemies.each do |npc|
    print("    #{ennemies.find_index(npc) + 1} - ")
    npc.show_state
  end
  print('> ')
  action = gets.chomp

  print spacer + ruler + spacer
  case action
  when 'a'
    player.search_weapon
  when 's'
    player.search_health_pack
  when '1'
    player.attacks(npc1)
  when '2'
    player.attacks(npc2)
  else
    print("Il faut faire un choix valide ! Reprenons.\n")
    next
  end

  print spacer + ruler + spacer

  print("C’est maintenant au tour des ennemis !\n")
  ennemies.each do |npc|
    next if npc.status.include? 'Mort'

    npc.attacks(player)
  end

  print spacer + ruler + spacer
end

if player.status.include? 'Mort'
  print(
    "AH! Tu es mort.\n",
    "Tu feras mieux la prochaine fois !\n"
  )
else
  print("FÉLICITATIONS CHAMPION, TU AS GAGNÉ LE JEU !\n")
end

binding.pry
