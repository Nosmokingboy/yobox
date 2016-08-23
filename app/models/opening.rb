class Opening < ApplicationRecord
  belongs_to :box
  belongs_to :user
  validates_associated: :user, :box
end
