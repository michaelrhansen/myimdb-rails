class User < ActiveRecord::Base
  has_many :movie_statuses
  has_many :activities
  
  # for people following this user
  has_many :relationships
  has_many :followers, :through=> :relationships
  
  # for people this user is following
  has_many :following_relationships, :class_name=> 'Relationship', :foreign_key=> 'follower_id'
  has_many :followings, :source=> :user, :through=> :following_relationships
  
  # friends
  has_many :friendship_relationships, :class_name=> 'Relationship', :conditions=> { 'relationships.is_friend'=> true }
  has_many :friends, :through=> :friendship_relationships, :source=> :follower
  
  MovieStatus::Statuses.each do |status_id, value|
    has_many value[:association], :through=> :movie_statuses, :conditions=> { 'movie_statuses.status_id'=> status_id }, :source=> 'movie'
  end
  
  def display_name
    username.blank? ? twitter_username : username
  end
  
  # Checks if +user+ is following the current user
  # Returns a boolean
  def following?(user)
    !!relation_with(user)
  end
  
  # Checks if +user+ is friends with the current user
  # Returns a boolean
  def friend_with?(user)
    !!user.friendship_relationships.find_by_follower_id(id)
  end
  
  # Gets the relationship object for a +user+
  # Used in displaying the relationhip with +user+ in views
  # Returns a Relationship object
  def relation_with(user)
    user.relationships.find_by_follower_id(id)
  end
  
  def followings_and_self
    following_relationships.collect(&:user_id) + [id]
  end
end
