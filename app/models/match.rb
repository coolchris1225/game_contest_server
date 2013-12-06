class Match < ActiveRecord::Base
  belongs_to :contest
  belongs_to :referee
  belongs_to :manager, polymorphic: true
  has_many :players, through: :player_matches
  has_many :player_matches
  
  validates :manager, presence: true
  validates :status, presence: true
  validates_date :completion, :on_or_before => lambda { Time.now.change(:usec =>0) }, :if => :checkthefuture
  validates_datetime :earliest_start, :if => :checking
  validate :check_number_of_players
  
  def check_number_of_players
    if self.players && self.manager
      if self.players.count != self.manager.referee.players_per_game
        errors.add(:manager, "Too many/few players!")
      end 
    end 
  end
  
def checkthefuture
    if self.status != "Completed"
      return nil
    else
      return true
    end
  end
  
  def checking 
    if self.status=="Completed" 
      return nil
    elsif self.status=="Started"
      return nil
    else
      return true
    end
  end
  
  
end
