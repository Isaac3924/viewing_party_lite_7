class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
    
    @user = User.find(session[:user_id])
  end

  private
    def require_admin
      render file: "public/404.html" unless current_admin?
    end
end