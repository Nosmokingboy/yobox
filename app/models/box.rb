class Box < ApplicationRecord
  attr_accessor :box_duration
  belongs_to :user
  has_many :openings

  validates :title, :content, :latitude, :longitude, presence: true
  validates_associated :user

  reverse_geocoded_by :latitude, :longitude

  scope :limited, -> { where.not(openings_max: nil) }
  scope :nolimit, -> { where(openings_max: nil) }
  scope :alive,   -> { includes(:openings).where('expiration_date_time >= ?', DateTime.now).references(:openings) }
  scope :once,    -> { includes(:openings).where("openings_max < (SELECT COUNT(*) FROM openings WHERE box_id = boxes.id)").references(:openings) }
  scope :openables, -> { alive.or(once) }

  def is_unlockable?(latitude, longitude, limit_in_km, user)
    is_within_reach?(latitude, longitude, limit_in_km) && user.has_sufficient_credit?
  end

  def box_distance(latitude, longitude)
    d = Geocoder::Calculations.distance_between([latitude, longitude], [self.latitude, self.longitude])
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
  end

  def self.views(box)
    Opening.all.where("box_id=?",box.id).count
  end

  def is_within_reach?(latitude, longitude, limit_in_km)
    d = Geocoder::Calculations.distance_between([latitude, longitude], [self.latitude, self.longitude])
    d <= limit_in_km
  end
end
