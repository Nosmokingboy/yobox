class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :apropos ]

  def apropos
  end

end
