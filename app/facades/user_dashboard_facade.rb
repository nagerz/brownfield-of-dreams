# frozen_string_literal: true

# Facade for the user dashboard show
class UserDashboardFacade
  def initialize(user)
    @user = user
  end

  # is there a better name we could use here?
  def users_followed
    response = service.get_users_followed
    response.map do |user_data|
      GithubUser.new(user_data)
    end
  end

  def user_repos
    response = service.get_repos
    response.map do |repo_data|
      Repository.new(repo_data)
    end
  end

  def user_followers
    response = service.get_followers
    response.map do |user_data|
      GithubUser.new(user_data)
    end
  end

  def top_user_repos(quantity)
    user_repos[0, quantity]
  end

  def service
    GithubService.new(@user)
  end

  def user_bookmarked_videos
    @user.bookmarks
  end

  def user_friends
    # new_friends = []
    # @user.friends.each do |friend|
    #   new_friends << GithubUser.where(uid: friend.uid)
    # end
    @user.friends
  end
end
