require "rails_helper"

RSpec.describe "User Discover Page" do 
  before(:each) do 
    @user_1 = User.create!(username: "j_smitty", password: "1234", name: "Joe Smith", email: "joey_smithy@yahooey.com")
    @user_2 = User.create!(username: "s_smitty", password: "password", name: "Sam Smith", email: "sam_smithy@yahooey.com")

    visit login_path

    fill_in :email, with: @user_1.email
    fill_in :password, with: @user_1.password

    click_on "Log In"

    visit discover_path
  end

  describe "when visiting the user's discover page" do 
    it "has a button to discover top rated movies" do 
      expect(page).to have_button("Top Rated Movies")
    end

    it "has a field to search for movies by title" do 
      within(".search_movie_title") do
        expect(page).to have_field(:search)
      end
    end

    it "has a button to search by movie title" do 
      within(".search_movie_title") do
        expect(page).to have_button("Search by Movie Title")
      end
    end
  end

  describe "when clicking the top rated movies button", :vcr do 
    it "navigates to the movies results page" do 
      click_button "Top Rated Movies"
      expect(current_path).to eq("/movies")
    end
  end

  describe "when typing keywords to search and clicking the search button", :vcr do 
    it "it navigates to the results page" do 
      within(".search_movie_title") do
        fill_in(:search, with: "The Lion King")
        click_button("Search by Movie Title")

        expect(current_path).to eq("/movies")
      end
    end
  end
end