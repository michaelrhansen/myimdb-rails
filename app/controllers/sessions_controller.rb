class SessionsController < ApplicationController
  before_filter       :validate_request_has_parameters, :only=> :create
  skip_before_filter  :login_required

  # opens up in a popup window
  def new
    request_token                   = Twitter.auth_info.get_request_token(:oauth_callback=> register_session_url)
    session[:request_token]         = request_token.token
    session[:request_token_secret]  = request_token.secret
    request_token.authorize_url

    @redirection_url = request_token.authorize_url
    render :layout=> 'wait'
  end

  # closes the popup window and passes params to parent window
  def register
    @reload_path_for_popup = url_for(:overwrite_params=> { :action=> :create })
  end

  def create
    request_token = OAuth::RequestToken.new(Twitter.auth_info, session[:request_token], session[:request_token_secret])
    access_token  = request_token.get_access_token(:oauth_verifier=> params[:oauth_verifier])
    case response = Twitter.auth_info.request(:get, '/account/verify_credentials.json', access_token, { :scheme => :query_string })
    when Net::HTTPSuccess
      user_info = ActiveSupport::JSON.decode(response.body)

      twitter_id            = user_info['id']
      twitter_username      = user_info['screen_name']
      twitter_token         = { :token=> access_token.token, :secret => access_token.secret }
      twitter_profile_image = user_info['profile_image_url']
    end
    
    if twitter_id
      if user = User.find_by_twitter_id(twitter_id)
        
      else
        user = User.new(:twitter_id            => twitter_id,
                        :twitter_username      => twitter_username,
                        :twitter_token         => twitter_token,
                        :twitter_profile_image => twitter_profile_image)
        user.save
      end
      self.current_user = user
    else
      flash[:notice] = "Unable to authenticate your twitter account"
    end
    
    redirect_to home_path
    session[:request_token] = session[:request_token_secret] = nil
  end

  def destroy
    logout_killing_session!
    redirect_to home_path
  end

  private
    def validate_request_has_parameters
      if params[:denied]
        flash[:error] = "Access Denied"
        redirect_to :action=> :index
      elsif params[:oauth_verifier].blank? or session[:request_token].blank? or session[:request_token_secret].blank?
        flash[:error] = "Request is missing required parameters"
        redirect_to :action=> :index
      end
    end
end
