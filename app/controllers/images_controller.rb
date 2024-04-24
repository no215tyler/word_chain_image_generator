class ImagesController < ApplicationController
  def index
    images = ImageGenerate.where(http_status: 200).to_a
    @images = images.sample(5)
  end

  def gallery
    @pagy, @galleries = pagy(ImageGenerate.includes(:user).order("created_at DESC").where(http_status: 200), items: 8)
  end

  def show
    @image = ImageGenerate.find(params[:id])
  end

  def destroy
    image = ImageGenerate.find(params[:id])
    image.destroy
    redirect_to root_path
  end
end
