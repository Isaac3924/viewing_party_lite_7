class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
    
    @user = User.find(session[:user_id])
  end

  private
    def require_admin
      unless current_admin?
        flash[:error] = "You are not authorized to view this page."
        redirect_to root_path 
      end
    end
end