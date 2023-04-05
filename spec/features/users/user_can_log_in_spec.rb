require 'rails_helper'

RSpec.describe "Logging In" do
  it "can log in with valid credentials" do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"

    expect(current_path).to eq(dashboard_path)

    expect(page).to have_content("Welcome, #{user.username}!")
  end

  it "cannot log in with bad credentials" do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: "incorrect password"

    click_on "Log In"

    expect(current_path).to eq(login_path)

    expect(page).to have_content("Sorry, your credentials are bad.")
  end

  it "cannot log in with bad credentials 2" do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit login_path

    fill_in :email, with: "invalid"
    fill_in :password, with: "test"

    click_on "Log In"

    expect(current_path).to eq(login_path)

    expect(page).to have_content("Sorry, your email does not exist as a user.")
  end
end