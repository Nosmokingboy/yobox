class BoxesController < ApplicationController

  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    # TODO: get GPS from user
    @boxes = Box.all.near("17 place de la Bourse 33000", 5).openables

    @hash = Gmaps4rails.build_markers(@boxes) do |box, marker|
      marker.lat box.latitude
      marker.lng box.longitude
      marker.infowindow render_to_string(partial: "/boxes/infowindow", locals: { box: box })
    end
  end

  def create
    @box = Box.new(box_params)
    @box.user = current_user
    if @box.save
      redirect_to box_path(@box)
    else
      render :new
    end
  end

  def new
    @box = Box.new
  end

  def show
    @box = Box.find(params[:id])
    iframely = Iframely::Requester.new api_key: ENV['IFRAMELY_KEY']
    @iframe = iframely.get_oembed_json(@box.first_url)["html"].html_safe
  end

private

  def box_params
    params.require(:box).permit(:title, :content, :expiration_date_time, :icon, :maximum_openings, :latitude, :longitude)
  end
end

