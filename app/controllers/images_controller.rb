class ImagesController < ApplicationController
  def index
    images = ImageGenerate.where(http_status: 200).to_a
    @images = images.sample(5)
  end
end
