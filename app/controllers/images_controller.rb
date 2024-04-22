class ImagesController < ApplicationController
  def index
    images = ImageGenerate.where(http_status: 200).to_a
    @images = images.sample(5)
  end

  def gallery
    galleries = ImageGenerate.includes(:user).to_a
    @random_gallery = galleries.sample(8)
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
