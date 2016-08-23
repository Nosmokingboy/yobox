class Box < ApplicationRecord
  belongs_to :user
  has_many :openings

  validates :title, :content, :latitude, :longitude, :expiration_date_time, presence: true
  validates_associated :user
end
