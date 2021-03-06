class FacebookController < ApplicationController

  before_filter :facebook_auth
  before_filter :require_login, :except => :login

  helper_method :logged_in?, :current_user
  
  def likes
    @likes_by_category = current_user.likes_by_category
  end

  def index
    @friends = current_user.friends
  end

  def login
  end

  def friends_comment_stats
    @id = params[:id]
    @stats = current_user.friends_comment_stats(@id)
    @friends_name = current_user.friends_name(@id)
    respond_to do |format|
      format.js
    end
  end

  protected

    def logged_in?
      !!@user
    end

    def current_user
      @user
    end

    def require_login
      unless logged_in?
        redirect_to :action => :login
      end
    end

    def facebook_auth
      @oauth = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET_KEY'])
      if fb_user_info = @oauth.get_user_info_from_cookie(request.cookies)
        @graph = Koala::Facebook::API.new(fb_user_info['access_token'])
        @user = User.new(@graph, fb_user_info['user_id'])
      end
    end
end
