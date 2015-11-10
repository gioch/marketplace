class Order < ActiveRecord::Base
  ## validators
  validates :address, :city, :state, presence: true

  ## relationships
  belongs_to :product
  belongs_to :buyer, class_name: 'User'
  belongs_to :seller, class_name: 'User'

  ## delegates
  ## Implemented 'Law of Demeter' pattern with delegate
  delegate :name, :price, :image_url, to: :product, prefix: 'product', allow_nil: true
  delegate :name, to: :seller, prefix: 'seller', allow_nil: true
  delegate :name, to: :buyer, prefix: 'buyer', allow_nil: true

  ## scopes
  scope :latest, -> { order("created_at DESC") }
  scope :user_is_seller, -> (user) { where(seller: user) }
  scope :user_is_buyer, -> (user) { where(buyer: user) }


  ## methods
  def self.latest_sold_by_user(user)
    user_is_seller(user).latest
  end

  def self.latest_bought_by_user(user)
    user_is_buyer(user).latest
  end

end
