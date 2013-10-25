class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page], :per_page => 10)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @microposts = @user.microposts.paginate(page: params[:page], :per_page => 10)
  end

  # GET /users/new
  def new
    @user = User.new    
    render :layout => "signup"
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, notice: "Welcome to #{app_name}"  }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new', :layout => "signup" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Profile Updated' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    name = @user.name
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "The profile with name: #{name} was removed" }
      format.json { head :no_content }
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :timezone)
    end

    def correct_user
      if !current_user?(@user) && !current_user.admin?
        redirect_to(root_url)
      end
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end         
end
