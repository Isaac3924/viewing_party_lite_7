class UsersController < ApplicationController
  def show 
    if session[:user_id] == nil
      redirect_to root_path
      flash[:error] = "You must be logged in or registered to access your dashboard."
    else
      @user = User.find(session[:user_id])
      if session[:user_id] == @user.id
        @movie_details = @user.movie_ids.map do |movie_id|
          facade = UserFacade.new(nil, nil)
          facade.get_movie_details(movie_id)
          facade.details
        end
      else  
        redirect_to login_path
      end
    end
  end

  def new

  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:notice] = "#{user.username} has been registered."
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:error] = user.errors.full_messages.join(', ')
      redirect_to "/register"
    end
  end

  def discover
    if session[:user_id] == nil
      flash[:error] = "You must be logged in or registered to access discover page."
      redirect_to root_path
    else
      @user = User.find(session[:user_id])
    end
  end

  def movie_results 
    search = params[:search]
    top_rated_search = params[:top_rated_search]
    
    @user = User.find(session[:user_id])

    facade = UserFacade.new(search, top_rated_search)
    @movie_results = facade.determine_search
  end
  
  def movie_details 
    facade = UserFacade.new(nil, nil)
    facade.get_movie_details(params[:movie_id])
  
    @details = facade.details 
    @reviews = facade.reviews
    @credits = facade.credits
  end

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])
    if user == nil
      flash[:error] = "Sorry, your email does not exist as a user."
      redirect_to login_path
    else
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.username}!"

        if user.admin?
          redirect_to admin_dashboard_index_path
        else
          redirect_to dashboard_path
        end
      else
        flash[:error] = "Sorry, your credentials are bad."
        redirect_to login_path
      end
    end
  end

  def logout
    if session[:user_id] != nil
      session[:user_id] = nil
      redirect_to root_path
    else
      flash[:error] = "Sorry, you cannot logout if you are not logged in."
      redirect_to root_path
    end
  end

  private
    def user_params
      params.permit(:username, :name, :email, :password, :password_confirmation)
    end
end