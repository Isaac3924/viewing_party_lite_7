require "rails_helper"

RSpec.describe "Landing Page" do 
  before(:each) do 
    @user_1 = User.create!(username: "j_smitty", password: "1234", name: "Joe Smith", email: "joey_smithy@yahooey.com")
    @user_2 = User.create!(username: "s_smitty", password: "password", name: "Sam Smith", email: "sam_smithy@yahooey.com")
    visit root_path
  end
  describe "when visiting  '/' " do 
    it "has the title of the application" do 
      expect(page).to have_content("Welcome to Viewing Party Lite")
    end

    it "has a button to create a new user" do 
      expect(page).to have_button("Create a New User")
    end

    it "goes to the register page when clicking register user" do 
      click_button "Create a New User"
      expect(current_path).to eq("/register")
    end

    it " has a list of existing users, which links to the users dashboard" do 
     
      within(".users") do 
        expect(page).to have_content("Existing Users")
        expect(page).to have_link("#{@user_1.email}")
        expect(page).to have_link("#{@user_2.email}")
      end

      within(".users") do 
        click_link("#{@user_1.email}")
        expect(current_path).to eq(login_path)
      end
    end

    it "has a link to go back to the landing page(on the top of every page)" do 
      expect(page).to have_link("Home")

      visit user_path(@user_1)
      click_link "Home"

      expect(current_path).to eq(root_path)
      expect("Home").to appear_before("Welcome to Viewing Party Lite")
    end
  end
end