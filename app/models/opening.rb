class Opening < ApplicationRecord
  belongs_to :box, counter_cache: true
  belongs_to :user

  validates_associated :user, :box

end
