class Box < ApplicationRecord
  belongs_to :user
  has_many :openings

  validates :title, :content, :latitude, :longitude, :expiration_date_time, presence: true
  validates_associated :user

  scope :limited, -> { where.not(openings_max: nil) }
  scope :nolimit, -> { where(openings_max: nil) }
  scope :alive,   -> { where('expiration_date_time >= ?', DateTime.now) }

  def self.openables
    Box.alive.map { |b| b if b.openings_max.nil? || views(b) < b.openings_max }.compact
  end

  private
  def self.views(box)
    cpt = Opening.all.where("box_id=?",box.id).count
  end

end
