class ViewingPartiesController <ApplicationController
  def new
    if session[:user_id] == nil
      redirect_to "/movies/#{params[:movie_id]}"
      flash[:error] = "You must be logged in or registered to create a viewing party."
    else
      @users = User.all.where.not(id: session[:user_id])
  
      @user = User.find(session[:user_id])
  
      facade = UserFacade.new(nil, nil)
      facade.get_movie_details(params[:movie_id])
      @movie = facade.details
    end
  end

  def create
    user = User.find(session[:user_id])
    viewing_party = ViewingParty.new(party_params)

    if viewing_party.save
      viewing_party.viewing_party_users.create!(user_id: session[:user_id]).update(is_host: true)
      
      users = params[:users].find_all do |num|
        num != "0" &&  num != session[:user_id]
      end
    
      users.each do |user_id|
        viewing_party_user = viewing_party.viewing_party_users.create!(user_id: user_id)
      end
      
      redirect_to dashboard_path
    else
      flash[:error] = "Error: Invalid form entry"
      redirect_to "/movies/#{params[:movie_id]}/viewing_party/new"
    end
  end

  private
    def party_params
      params.permit(:duration_of_party, :when, :start_time, :movie_id)
    end
end