class Box < ApplicationRecord
  attr_accessor :box_duration
  belongs_to :user
  has_many :openings

  validates :title, :content, :latitude, :longitude, presence: true
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

  def first_url
    url_regex = /https?:\/\/[\da-z\.-]+\.[a-z\.]{2,6}[\/\w\.?=&-]*\/?/
    content.match(url_regex).to_s if content.match(url_regex)
  end

  def set_duration(duration)
    case duration
      when "1 single opening"
        self.openings_max = 2
        self.expiration_date_time = DateTime.now + 7.days
      when "1 day"
        self.expiration_date_time = DateTime.now + 1.days
      when "7 days"
        self.expiration_date_time = DateTime.now + 7.days
    end
  end

  def time_left
    time_left = ((self.expiration_date_time - DateTime.now) / 60 / 60).round
    "#{time_left} hours !!"
  end

  def self.views(box)
    cpt = Opening.all.where("box_id=?",box.id).count
  end

end
