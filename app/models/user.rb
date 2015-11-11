class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## validators
  validates :name, presence: true

  ## relationships
  has_many :products, dependent: :destroy
  has_many :sales, class_name: 'Order', foreign_key: 'seller_id'
  has_many :puchases, class_name: 'Order', foreign_key: 'buyer_id'

  ## methods
  def recipient_blank?
    self.recipient.blank?
  end

  def set_recipient_id(recipient_id)
    self.recipient = recipient_id
    save
  end

end
