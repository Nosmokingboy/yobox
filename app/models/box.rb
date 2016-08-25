class Box < ApplicationRecord
  belongs_to :user
  has_many :openings

  validates :title, :content, :latitude, :longitude, :expiration_date_time, presence: true
  validates_associated :user

  reverse_geocoded_by :latitude, :longitude

  scope :limited, -> { where.not(openings_max: nil) }
  scope :nolimit, -> { where(openings_max: nil) }
  scope :alive,   -> { where('expiration_date_time >= ?', DateTime.now) }
  scope :openables, -> { alive.map { |b| b if b.openings_max.nil? || views(b) < b.openings_max }.compact }

  # def self.openables
  #   Box.alive.map { |b| b if b.openings_max.nil? || views(b) < b.openings_max }.compact
  # end
  #
  def can_be_openned_by?(user)
    # get user position in session
    # compare with self.distance_from([40.714,-100.234]) < 500
  end

  private
  def self.views(box)
    cpt = Opening.all.where("box_id=?",box.id).count
  end

end
