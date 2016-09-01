class User < ApplicationRecord
  mount_uploader :picture, PictureUploader
  has_many :boxes
  has_many :openings

  validates :first_name, :last_name, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  def self.find_for_facebook_oauth(auth)
    user_params = auth.to_h.slice("provider", "uid")
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:remote_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)

    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.where(email: auth.info.email).first # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end

    return user
  end

  def openings_count
    self.openings.count
  end

  def box_count
    self.boxes.count
  end

  def own_boxes_openings_count
    self.boxes.map { |box| box.openings.count }.inject(0,:+)
  end

  def average_rating
    all_ratings = []
    self.boxes.each do |box|
      if box.openings.pluck(:rating).empty? == false
        all_ratings << box.openings.pluck(:rating)
      end
    end
    tabs = all_ratings.flatten.compact
    if tabs.empty?
      -1
    else
      result = tabs.inject(:+) / tabs.count
      (result*2).round / 2.0
    end
  end

  # def average_rating
  #   self.boxes.each do |box|
  #     if box.openings.pluck(:rating).empty? == false
  #       all_ratings = box.openings.pluck(:rating).flatten.compact
  #       all_ratings = all_ratings.inject(:+) / all_ratings.count
  #       all_ratings
  #     end
  #   end
  # end

  def meter
    10 + (self.boxes.count * 2) + (self.own_boxes_openings_count / 10) - self.openings_count
  end

end
