class MovieStatus < ActiveRecord::Base
  Statuses = {
    1=> { :text=> "I have this movie", :status=> "has this movie", :weightage=> 1, :logical_group=> 1, :association=> 'have' },
    2=> { :text=> "I like this movie", :status=> "likes this movie", :weightage=> 2, :logical_group=> 2, :association=> 'like' },
    3=> { :text=> "I hate this movie", :status=> "hates this movie", :weightage=> -2, :logical_group=> 2, :association=> 'hate' },
    4=> { :text=> "I have seen this movie", :status=> "has seen this movie", :weightage=> 1, :logical_group=> 4, :association=> 'seen' },
    5=> { :text=> "I want to see this movie", :status=> "wants to see this movie", :weightage=> 1, :logical_group=> 4, :association=> 'want' }
  }
  LogicalGroups = Statuses.inject({}) { |group, value| group[value[1][:logical_group]] ||= []; group[value[1][:logical_group]] << value[0]; group }

  belongs_to :user
  belongs_to :movie, :counter_cache=> true
  belongs_to :resource, :polymorphic=> true
  has_one    :activity, :as=> :resource, :dependent=> :destroy

  validates_uniqueness_of :status_id, :scope=> [:movie_id, :user_id]

  after_create :create_activity
  after_create :add_popularity
  after_create :remove_conflicting_statuses
  
  def self.toggle(options)
    if movie_status = MovieStatus.find_by_status_id_and_movie_id_and_user_id(
      options[:status_id],
      options[:movie_id],
      options[:user_id])
      movie_status.destroy
    else
      movie_status = MovieStatus.new(:user_id=> options[:user_id], :status_id=> options[:status_id], :movie_id=> options[:movie_id])
      movie_status.save
    end
  end

  private
    def create_activity
      Activity::MovieStatusActivity.create(
        :content  => Statuses[status_id][:status], 
        :user_id  => user_id,
        :movie_id => movie_id,
        :resource => self)
    end

    def add_popularity
      movie.increment!(:popularity, Statuses[status_id][:weightage])
    end
    
    def remove_conflicting_statuses
      if logical_group = LogicalGroups[Statuses[status_id][:logical_group]] and !logical_group.blank?
        conflicting_statuses = logical_group - [status_id]
        conflicting_statuses.each do |conflicting_status|
          MovieStatus.destroy_all(
            :status_id  => conflicting_status,
            :movie_id   => movie_id,
            :user_id    => user_id)
        end
      end
    end
end
