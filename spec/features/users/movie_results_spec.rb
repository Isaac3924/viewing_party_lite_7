require "rails_helper"

RSpec.describe "Movie Results Page" do 
  before(:each) do 
    @user_1 = User.create!(username: "j_smitty", password: "1234", name: "Joe Smith", email: "joey_smithy@yahooey.com")
    @user_2 = User.create!(username: "s_smitty", password: "password", name: "Sam Smith", email: "sam_smithy@yahooey.com")

    visit login_path

    fill_in :email, with: @user_1.email
    fill_in :password, with: @user_1.password

    click_on "Log In"

    visit discover_path
  end

  describe "top rated search result page", :vcr do 
    it " has a title of each movie as a link to the movie's detail page" do 
      click_button "Top Rated Movies"

      expect(current_path).to eq("/movies")

      within(".movie_results") do 
        expect(page).to have_content("Title", count: 20)
        expect(page).to have_content("The Godfather")
      end

      within(".movie_id_238") do 
        expect(page).to have_content("The Godfather")
        expect(page).to have_link("The Godfather")
        expect(page).to have_content("Vote Average: 8.7")
      end
    end

    it "has the vote average of the movie" do 
      click_button "Top Rated Movies"

      within(".movie_id_238") do 
        expect(page).to have_content("Vote Average: 8.7")
      end
    end

    it "has a limit of 20 movies on the page" do 
      click_button "Top Rated Movies" 

      expect(page).to have_content("Title", count: 20)
    end

    it "navigates to the movie details page when a link is clicked" do 
      click_button "Top Rated Movies" 
      
      click_link "The Godfather"

      expect(current_path).to eq("/movies/238")
    end

  end

  describe "search by title result page", :vcr do 
    it 'can search for a movie by the title, display the vote average and limit results to 20' do 
      within(".search_movie_title") do
        fill_in(:search, with: "The Lion King")
        click_button("Search by Movie Title")

        expect(current_path).to eq("/movies")
      end

      within(".movie_results") do 
        expect(page).to have_content("The Lion King")
        expect(page).to have_content("Title", count: 20)

        expect(page).to_not have_content("The Godfather")
      end

      within(".movie_id_420818") do 
        expect(page).to have_content("The Lion King")
        expect(page).to have_link("The Lion King")
        expect(page).to have_content("Vote Average: 7.1")

        expect(page).to_not have_content("Vote Average: 8.7")
      end
    end
  end

  describe "button to discover page", :vcr do 
    it "takes the user back to the discover page from the movie results page" do 
      visit "/movies" 

      expect(page).to have_button("Discover Page")

      click_button "Discover Page"

      expect(current_path).to eq("/discover")
    end
  end
end