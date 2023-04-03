require "rails_helper"

RSpec.describe "Movie Details Page" do 
  before(:each) do 
    @user_1 = User.create!(username: "j_smitty", password: "1234", name: "Joe Smith", email: "joey_smithy@yahooey.com")
    @user_2 = User.create!(username: "s_smitty", password: "password", name: "Sam Smith", email: "sam_smithy@yahooey.com") 

    visit "/users/#{@user_1.id}/discover" 
  end

  describe "when visiting the movies details page", :vcr do
    it "has buttons for create new viewing party and return to discover page" do 
      click_button "Top Rated Movies"
      click_link "The Godfather"
      visit "/users/#{@user_1.id}/movies/238" 

      expect(page).to have_button("Create Viewing Party for The Godfather")
      expect(page).to have_button("Discover Page") 
    end

    it "has information about the movie" do 
      click_button "Top Rated Movies"
      click_link "The Godfather"
      visit "/users/#{@user_1.id}/movies/238" 

      summary = "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge."
      cast = {"Marlon Brando"=>"Don Vito Corleone",
              "Al Pacino"=>"Don Michael Corleone",
              "James Caan"=>"Santino 'Sonny' Corleone",
              "Robert Duvall"=>"Tom Hagen",
              "Richard S. Castellano"=>"Pete Clemenza",
              "Diane Keaton"=>"Kay Adams",
              "Talia Shire"=>"Constanzia 'Connie' Corleone-Rizzi",
              "Gianni Russo"=>"Carlo Rizzi",
              "Sterling Hayden"=>"Capt. Mark McCluskey",
              "Al Lettieri"=>"Virgil 'The Turk' Sollozzo"
            }

      within(".movie_details") do 
        expect(page).to have_content("Movie Title: The Godfather") 
        expect(page).to have_content("Vote Average: 8.7") 
        expect(page).to have_content("Runtime: 175") 
        expect(page).to have_content("Genre: Drama, Crime") 
        expect(page).to have_content("Summary: #{summary}") 
      end

      within(".cast") do 
        expect(page).to have_content("Actor: Marlon Brando") 
        expect(page).to have_content("Character: Don Vito Corleone")
        expect(page).to have_content("Actor: Al Lettieri") 
        expect(page).to have_content("Character: Virgil 'The Turk' Sollozzo")
        expect(page).to_not have_content("Actor: Hillary Duff")
        expect(page).to_not have_content("Character: Buggs Bunny")
      end

      within(".reviews") do 
        expect(page).to have_content("Review Count: 3")  
        expect(page).to have_content("Name: futuretv") 
        expect(page).to have_content("Name: crastana") 
        expect(page).to have_content("Rating: 10.0", count: 2) 
      end
    end
  end
end