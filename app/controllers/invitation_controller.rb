class InvitationController < ApplicationController

  def new

  end

  def create
    github_service = GithubService.new(current_user)
    user = github_service.get_user(params[:handle])
    github_user = GithubUser.new(user)
    
    if github_user.email
      InviteMailer.invite(current_user, github_user).deliver_now
      flash[:notice] = "Successfully sent invite!"
    else
      flash[:error] = "The Github user you selected doesn't have an email address associated with their account."
    end
    redirect_to dashboard_path
  end
end