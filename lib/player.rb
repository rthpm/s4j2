# frozen_string_literal: true

# This class handles player’s registration and status changes
class Player
  attr_accessor :name, :life_points, :status

  def initialize(name)
    @name = name
    @life_points = rand(10..20) # make it spicier.
    @status = ['En vie']
  end

  def show_state
    if @status.include? 'En vie'
      print("#{@name} a #{@life_points} points de vie.\n")
    else
      print("#{@name} est mort.\n")
    end
    # status_detail if @status.length > 1 # TODO
  end

  def gets_damage(damage)
    @life_points -= damage
    if @life_points <= 0
      print("#{@name} est mort !\n")
      @life_points = 0 # We reset it because video games never have negative hp!
      @status.delete('En vie') # A small helper with added bonuses like status management.
      @status << 'Mort'
    else
      print("#{@name} a perdu #{damage} points de vie.\n",
            "Il lui en reste #{@life_points}.\n")
    end
  end

  def attacks(victim)
    print("#{@name} attaque #{victim.name} !\n")

    damage = compute_damages
    if damage.zero?
      print("Mais il a raté son coup !\n")
    else
      victim.gets_damage(damage)
    end
  end

  def dice_roll
    rand(1..6)
  end

  def compute_damages
    dice_roll - 1 # we deal damages between 0 and 5 to have missing hits
  end
end

# Playable character specific mechanics
class HumanPlayer < Player
  attr_accessor :weapon_level

  def initialize(player_name)
    super(player_name)
    @weapon_level = 1
    @life_points = rand(50..100) # Make it spicier
  end

  def show_state
    if @status.include? 'En vie'
      print("#{@name} a #{@life_points} points de vie et une arme de niveau #{@weapon_level}.\n")
    else
      print("#{@name} est mort.\n")
    end
  end

  def compute_damages
    (dice_roll - 1) * @weapon_level
  end

  def search_weapon
    weapon_found = dice_roll
    print("Tu as trouvé une arme de niveau #{weapon_found}\n")
    if @weapon_level < weapon_found
      @weapon_level = weapon_found
      print("Elle a l’air meilleure que l’actuelle, on les échange !\n")
    else
      print("C'est pas terrible, on garde ton arme.\n")
    end
  end

  def search_health_pack
    health_dice = dice_roll
    if health_dice == 1
      print('Tu n’as rien trouvé !')
    elsif health_dice >= 2 && health_dice <= 5
      @life_points += 50
      printf("Tu as trouvé un pack de 50 points de vie !\n")
    elsif health_dice == 6
      @life_points += 80
      printf("Tu as trouvé un pack de 80 points de vie !\nOn se met bien on dirait !\n")
    end
    @life_points = 100 if @life_points > 100
  end
end
