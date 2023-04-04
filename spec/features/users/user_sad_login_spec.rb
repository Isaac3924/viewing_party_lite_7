require 'rails_helper'

RSpec.describe "Bad Log In" do
  it "takes me to log in when I click my dashboard and I am not logged in." do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit root_path

    click_on "#{user.email}"

    expect(current_path).to eq(login_path)
  end

  it "takes me to my dashboard when I am logged in." do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"

    expect(current_path).to eq(user_path(user))
    
    expect(page).to have_content("Welcome, #{user.username}!")
    
    visit root_path

    click_on "#{user.email}"

    expect(current_path).to eq(user_path(user))

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