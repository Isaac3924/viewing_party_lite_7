require 'rails_helper'

RSpec.describe "Authorization" do
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
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password

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
    visit user_path(@user_3)

    expect(current_path).to eq(root_path)

    expect(page).to have_content("You must be logged in or registered to access your dashboard.")
  end

  xit "When clicking Log Out, I'm taken to the landing page, and can see links to log in and create a new user" do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"

    visit root_path

    click_on "Log Out"

    expect(current_path).to eq(root_path)

    expect(page).to_not have_link("Log Out")
    expect(page).to have_link("Log In")
    expect(page).to have_button("Create a New User")
  end
end