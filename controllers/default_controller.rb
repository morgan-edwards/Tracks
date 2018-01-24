require_relative "tracks_controller"
require_relative "../models/default_model"
require 'byebug'

class DefaultController < TracksController
  def index
    @defaults = DefaultModel.all
    render :index
  end

  def new
    @default = DefaultModel.new(
      user_id: params[:user_id],
      text: params[:text]
    )
  end
end
