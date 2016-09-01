class OpeningsController < ApplicationController

  def update
    @opening = Opening.find(params[:id])
    @opening.update(opening_params)

    respond_to do |format|
      format.js
    end
  end

  private

  def opening_params
    params.require(:opening).permit(:rating)
  end

end
