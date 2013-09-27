class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy

  def create
  	@micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      redirect_to root_url, notice: "Micropost created!"
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url, notice: "your micropost was deleted"
  end


  private
    def micropost_params
      params.require(:micropost).permit(:content, :title)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end 
end
