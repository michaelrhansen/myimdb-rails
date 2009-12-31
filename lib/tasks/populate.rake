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
      rescue 
        p "Error in: #{name}"
      end
    end
  end
end