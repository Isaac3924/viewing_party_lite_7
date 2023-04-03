class UsersController < ApplicationController
  def show 
    @user = User.find(params[:id])
    @movie_details = @user.movie_ids.map do |movie_id|
      facade = UserFacade.new(nil, nil)
      facade.get_movie_details(movie_id)
      facade.details
    end
  end

  def new

  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:notice] = "#{user.username} has been registered."
      redirect_to user_path(user)
    else
      flash[:error] = user.errors.full_messages.join(', ')
      redirect_to "/register"
    end
  end

  def discover
    @user = User.find(params[:id])
  end

  def movie_results 
    search = params[:search]
    top_rated_search = params[:top_rated_search]
    
    @user = User.find(params[:id])

    facade = UserFacade.new(search, top_rated_search)
    @movie_results = facade.determine_search
  end
  
  def movie_details 
    facade = UserFacade.new(nil, nil)
    facade.get_movie_details(params[:movie_id])

    @details = facade.details 
    @reviews = facade.reviews
    @credits = facade.credits
    @user = User.find(params[:user_id])
  end

  private
    def user_params
      params.permit(:username, :name, :email, :password, :password_confirmation)
    end
end