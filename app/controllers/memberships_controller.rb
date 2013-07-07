class MembershipsController < ApplicationController
  before_filter :ensure_team_admin

  def create
    user = User.find(params[:user_id])
    current_team.add(user, params[:key])
    render :json => {}, :status => :created
  end

  def destroy
    user = User.find(params[:id])
    current_team.membership(user).destroy
    head :ok
  end
end
