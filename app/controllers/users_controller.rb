class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @pagy, @images = pagy(@user.image_generates.order("created_at DESC").where(http_status: 200), items: 9)
  end
end
