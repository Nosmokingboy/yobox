class UsersController < ApplicationController

  def stats
    @user = current_user
  end

end
