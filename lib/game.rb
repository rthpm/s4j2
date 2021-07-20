# frozen_string_literal: true

# This class handles the interraction logic between npcs and players
class Game
  attr_accessor :human_player, :enemies_in_sight

  def initialize(human_player)
    @human_player = HumanPlayer.new(human_player)
    @enemies_in_sight = []
    @player_left = 10
  end

  def kill_player(player)
    @enemies_in_sight.delete player
    @player_left -= 1
  end

  def still_ongoing
    if @human_player.status.include?('En vie') && @enemies_in_sight.length.positive?
      true
    else
      false
    end
  end

  def new_players_in_sight
    print("Tout les joueurs sont déjà en vue.\n") if @enemies_in_sight.length == @player_left
    spawn_score = rand(1..6)
    if spawn_score == 1
      print("Pas de nouveau joueur.\n")
    elsif spawn_score >= 2 && spawn_score <= 4
      new_player = "enemy_#{rand(1000..1999)}"
      @enemies_in_sight << Player.new(new_player)
      print("Le joueur #{new_player} entre en jeu !\n")
    elsif spawn_score >= 5
      new_player1 = "enemy_#{rand(1000..1999)}"
      new_player2 = "enemy_#{rand(1000..1999)}"
      @enemies_in_sight << Player.new(new_player1)
      @enemies_in_sight << Player.new(new_player2)
      print("Les joueur #{new_player1} et #{new_player2} entre en jeu !\n")
    end
  end

  def show_players
    @human_player.show_state
    @enemies_in_sight.each(&:show_state)
  end

  def menu
    # rubocop:disable Layout/HeredocIndentation
    # An heredoc because why not?
    base = <<~ENDOFMENU
Quelle action veux-tu effectuer?
    a - Chercher une meilleure arme
    s - Chercher à se soigner
Ou préfères-tu attaquer un enemi ?
    ENDOFMENU
    # rubocop:enable Layout/HeredocIndentation
    print base
    (0..(@enemies_in_sight.length - 1)).each do |i|
      print "    #{i} - "
      @enemies_in_sight[i].show_state
    end
  end

  def menu_choice
    print('> ')
    choice = gets.chomp
    if choice == 'a' # An if loop because case it too dumb to deal with type conversion
      @human_player.search_weapon
    elsif choice == 's'
      @human_player.search_health_pack
    elsif choice.to_i.to_s == choice && (choice.to_i >= 0 && choice.to_i <= @enemies_in_sight.length)
      npc = enemies_in_sight[choice.to_i]
      @human_player.attacks(npc)
      kill_player(npc) if npc.life_points.zero?
    else
      printf("Faites un choix valide !\n")
      menu_choice
    end
  end

  def enemies_attack
    @enemies_in_sight.each do |npc|
      npc.attacks(@human_player)
    end
  end

  def end_game
    print("Partie terminée.\n")
    if human_player.status.include? 'Mort'
      print("C’est perdu. Tu joueras mieux la prochaine fois.\n")
    else
      print("Bravo ! Tu as tout cassé !\n")
    end
  end
end
