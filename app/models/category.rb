class Category < ActiveRecord::Base
  ## relationships
  has_many :products
end
