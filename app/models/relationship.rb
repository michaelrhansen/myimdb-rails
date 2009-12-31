class Relationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :follower, :class_name=> 'User'
  
  validates_presence_of   :user_id, :follower_id
  validates_uniqueness_of :user_id, :scope=> :follower_id
  validate                :user_and_follower_cant_be_same
  
  before_create :update_existing_follower
  after_destroy :remove_relationship
  
  def has_update_access?(user)
    follower_id == user.id or user_id == user.id
  end
  
  def formatted_error_message
    if user and user == follower
      "#{user.login.capitalize} cannot follow himself"
    else
      'You are already following this user'
    end
  end
  
  private
    def update_existing_follower
      if relationship = follower.relationships.find_by_user_id(follower_id)
        self.friend = true
        relationship.update_attributes(:is_friend=> true, :friendship_requested=> false)
      end
    end
    
    def remove_relationship
      if relationship = follower.relationships.find_by_user_id(follower_id)
        relationship.update_attribute(:is_friend, false)
      end
    end
    
    def user_and_follower_cant_be_same
      if user_id == follower_id
        self.errors.add(:user, "can't be same as follower")
      end
    end
end
