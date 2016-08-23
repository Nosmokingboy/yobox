class Opening < ApplicationRecord
  belongs_to :box
  belongs_to :user
  validates_associated: :user, :box

  validate :close_enough

  def close_enough
    #ici la logique pour savoir si la box est suffisament proche
  end
end
