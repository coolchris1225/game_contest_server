class Referee < ActiveRecord::Base
  belongs_to :user
  has_many :contests
  has_many :matches, as: :manager
  
  validates :name, presence: true, uniqueness: true
  VALID_URL_REGEX = /https?:\/\/[\S]+/i 
  validates :rules_url, presence: true, format: { with: VALID_URL_REGEX }
  validates :players_per_game, presence: true, :numericality => { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10, only_integer: true}
  validates :file_location, presence: true
      
  include Uploadable
  
  def referee
    self
  end
  
end
