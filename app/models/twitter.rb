class Twitter < ActiveRecord::Base
  attr_accessor   :request_token, :oauth_verifier
  
  before_validation :check_credentials
  validate          :push_oauth_errors
  
  serialize         :twitter_token, Hash
  
  def friends
    friends = autherization.request('get', "#{CredentialsTwitterUrl}/statuses/friends.json").body
    ActiveSupport::JSON.decode(friends)
  end
  
  def followers
    followers = autherization.request('get', "#{CredentialsTwitterUrl}/statuses/followers.json").body
    ActiveSupport::JSON.decode(followers)
  end
  
  def status(message)
    autherization.post("#{CredentialsTwitterUrl}/statuses/update.json", { :status=> message })
  end
  
  def self.auth_info
    OAuth::Consumer.new(CredentialsTwitterKey, CredentialsTwitterSecret, { :site=> CredentialsTwitterUrl })
  end
  
  private
    # CALLBACK
    def check_credentials
      access_token  = request_token.get_access_token(:oauth_verifier=> oauth_verifier)
      case response = Twitter.auth_info.request(:get, '/account/verify_credentials.json', access_token, { :scheme => :query_string })
      when Net::HTTPSuccess
        user_info = ActiveSupport::JSON.decode(response.body)

        self.authentication_id  = user_info['id']
        self.username           = user_info['screen_name']
        self.token              = { :token=> access_token.token, :secret => access_token.secret }
      end
    rescue OAuth::Unauthorized
      @token_expired = true
    end

    # CALLBACK
    def push_oauth_errors
      self.errors.add(:request_token, "has expired") if @token_expired
    end
    
    def autherization
      @autherization ||= OAuth::AccessToken.new(Twitter.auth_info, token['token'], token['secret'])
    end
end
