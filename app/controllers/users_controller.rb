class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @pagy, @images = pagy(@user.image_generates.where(http_status: 200), items: 9)
  end
end
