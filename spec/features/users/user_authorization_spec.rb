require 'rails_helper'

RSpec.describe "Authorization", :vcr do
  before(:each) do 
    @user_1 = User.create!(username: "j_smitty", password: "1234", name: "Joe Smith", email: "joey_smithy@yahooey.com")
    @user_2 = User.create!(username: "s_smitty", password: "password", name: "Sam Smith", email: "sam_smithy@yahooey.com")
    @user_3 = User.create!(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")
    visit root_path
  end

  it "As a visitor, when visiting the landing page, I do not see a list of existing users" do
    visit root_path

    within(".users") do 
      expect(page).to_not have_content("Existing Users")
      expect(page).to_not have_content("#{@user_1.email}")
      expect(page).to_not have_content("#{@user_2.email}")
      expect(page).to_not have_content("#{@user_3.email}")
    end
  end

  it "As a registered user when visiting landing page, I see a list of email addresses" do
    visit login_path

    fill_in :email, with: @user_3.email
    fill_in :password, with: @user_3.password

    click_on "Log In"

    visit root_path

    within(".users") do 
      expect(page).to have_content("Existing Users")
      expect(page).to have_content("#{@user_1.email}")
      expect(page).to have_content("#{@user_2.email}")
      expect(page).to have_content("#{@user_3.email}")
    end
  end

  it "As a visitor, when visiting my dashboard, I remain on the ladning page, and see a message informing me to log in to access it" do
    visit dashboard_path

    expect(current_path).to eq(root_path)

    expect(page).to have_content("You must be logged in or registered to access your dashboard.")
  end

  it "As a visitor if I go to a movie show page and click the button to create a viewing party, I am redirected back to the movie show page with an error message" do
    visit "/movies/238"
    
    click_on "Create Viewing Party for The Godfather"

    expect(current_path).to eq("/movies/238")

    expect(page).to have_content("You must be logged in or registered to create a viewing party.")
  end
end