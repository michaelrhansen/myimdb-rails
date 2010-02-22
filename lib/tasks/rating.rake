namespace :regenerate do 
  desc "Regenerate rating for all the users"
  task :rating => :environment do
    MovieWriter.all.each(&:add_metadata_to_writer)
    MovieDirector.all.each(&:add_metadata_to_director)
  end
end