require 'rails_helper'

RSpec.describe "Log Out" do
  it "When logged in and visiting landing page, I do not see a link to log in or create a new user" do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"

    visit root_path

    expect(page).to_not have_link("Log In")
    expect(page).to_not have_button("Create a New User")
  end

  it "When logged in and visiting landing page, I see a link to Log Out" do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"

    visit root_path

    expect(page).to have_link("Log Out")
  end

  it "When clicking Log Out, I'm taken to the landing page, and can see links to log in and create a new user" do
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