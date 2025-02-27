class UrlsController < ApplicationController
  before_action :set_url, only: [:redirect, :destroy]

  def index
    @urls = Url.order(created_at: :desc)
    render json: {
      notice: "Successfully fetched all URLs",
      urls: @urls.map { |url| url.to_response(request) }
    }
  end

  def create
    @url = Url.create(url_params)

    if @url.persisted?
      render json: { notice: "Successfuly created shortend URL", url: @url.to_response(request) }
    else
      render json: { errors: @url.errors.full_messages }, status: 422
    end
  end

  def redirect
    if @url
      redirect_to @url.long_url, allow_other_host: true, status: :moved_permanently
    else
      render json: { error: "Shortened URL not found" }, status: :not_found
    end
  end

  def destroy
    if @url
      @url.destroy
      render json: { notice: "Shortened URL deleted successfully" }
    else
      render json: { error: "Shortened URL not found" }, status: :not_found
    end
  end

  private

    def url_params
      params.require(:url).permit(:long_url)
    end

    def set_url
      @url = Url.find_by(short_code: params[:short_code])
    end
end
