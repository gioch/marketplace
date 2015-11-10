class Product < ActiveRecord::Base
  ## paperclip
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "default.jpeg"
  
  ## validators
  validates_attachment_presence :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :name, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  ## relationships
  has_many   :orders
  belongs_to :category
  belongs_to :user

  ## delegates
  ## Implemented 'Law of Demeter' pattern with delegate
  delegate :id, :name, to: :category, prefix: 'category', allow_nil: true
  delegate :id, :name, to: :user, prefix: 'user', allow_nil: true
  delegate :url, to: :image, prefix: 'image', allow_nil: true

  ## scopes
  scope :latest, -> { order("created_at DESC") }
  scope :of_user, -> (user) { where(user_id: user.id) }
  scope :by_category, -> (category_id) { where(category_id: category_id) }


  ## methods
  def self.latest_by_category(category_id)
    category_id.blank? ? Product.latest 
                       : Product.by_category(category_id).latest
  end

  def self.latest_by_category_for_user(user, category_id)
    latest_by_category(category_id).of_user(user)
  end

  def belongs_to_user?(user)
    self.user == user
  end

end
