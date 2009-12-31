class Activity < ActiveRecord::Base
  default_scope :order=> "id DESC"
  
  belongs_to :user
  belongs_to :movie

  named_scope :for_movie, lambda { |movie_id|
    { :conditions => movie_id ? { :movie_id => movie_id } : {} }
  }
  named_scope :for_user, lambda { |user|
    { :conditions => ["user_id in (?)", user.followings_and_self] }
  }
end
