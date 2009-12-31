class MovieStatus < ActiveRecord::Base
  Statuses = {
    "I have this movie"         => 1,
    "I like this movie"         => 2,
    "I hate this movie"         => 3,
    "I have seen this movie"    => 4,
    "I want to see this movie"  => 5
  }

  ActivityStatuses = {
    "has this movie"          => 1,
    "likes this movie"        => 2,
    "hates this movie"        => 3,
    "has seen this movie"     => 4,
    "wants to see this movie" => 5
  }
  ActivityStatusesMessages = ActivityStatuses.invert

  PopularityWeightage = {
    1=> 1,
    2=> 2,
    3=> -2,
    4=> 1,
    5=> 1
  }

  belongs_to :user
  belongs_to :movie, :counter_cache=> true

  validates_uniqueness_of :status_id, :scope=> [:movie_id, :user_id]

  after_create :create_activity
  after_create :add_popularity

  private
    def create_activity
      Activity::MovieStatusActivity.create(
        :content  => ActivityStatusesMessages[status_id], 
        :user_id  => user_id,
        :movie_id => movie_id)
    end

    def add_popularity
      movie.increment!(:popularity, PopularityWeightage[status_id])
    end
end
