namespace :db do 
  desc "Load demo data"
  task :populate => :environment do
   [
     "Spy Kids", 
     "Batman Begins", 
     "The Dark Knight",
     "Inglorious Basterds",
     "The Fourth Kind",
     "The Shining",
     "Iron Man",
     "Pans Labyrinth",
     "Kill Bill Vol 1",
     "Kill Bill Vol 2",
     "Sin City",
     "Pulp Fiction",
     "Avatar",
     "Resident Evil",
     "My Fair Lady",
     "Godfather"
    ].each do |name|
      begin
        Movie.create(:name=> name)
        p "Created: #{name}"
      rescue Exception=> ex
        p "Error in: #{name} because: #{ex.message}"
      end
    end
  end
  
  namespace :rebuild do
    desc "Drop/Create/Migrate/Populate the db"
    task :all => :environment do
      Rake::Task["db:drop"].invoke
      Rake::Task["db:create"].invoke
      Rake::Task["db:schema:load"].invoke
      Rake::Task["db:populate"].invoke
    end
  end
end