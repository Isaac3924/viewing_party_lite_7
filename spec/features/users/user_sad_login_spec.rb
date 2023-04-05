require 'rails_helper'

RSpec.describe "Bad Log In" do
  it "takes me to root page when I visit my dashboard and I am not logged in." do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit dashboard_path

    expect(current_path).to eq(root_path)
  end

  it "takes me to my dashboard when I am logged in." do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"

    expect(current_path).to eq(dashboard_path)
    
    expect(page).to have_content("Welcome, #{user.username}!")

    expect(current_path).to eq(dashboard_path)

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