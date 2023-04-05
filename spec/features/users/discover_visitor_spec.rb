require "rails_helper"

RSpec.describe "User Discover Page" do 
  before(:each) do 
    @user_1 = User.create!(username: "j_smitty", password: "1234", name: "Joe Smith", email: "joey_smithy@yahooey.com")
    @user_2 = User.create!(username: "s_smitty", password: "password", name: "Sam Smith", email: "sam_smithy@yahooey.com")

    visit discover_path
  end

  describe "when visiting the user's discover page as a visitor" do 
    it "redirects me to the landing page, with an error message" do 
      expect(current_path).to eq(root_path)
      expect(page).to have_content("You must be logged in or registered to access discover page.")
    end
  end
end