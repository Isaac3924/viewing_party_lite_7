require 'rails_helper'

RSpec.describe "Admin Login" do
  before(:each) do 
    @user_1 = User.create!(username: "j_smitty", password: "1234", name: "Joe Smith", email: "joey_smithy@yahooey.com")
    @user_2 = User.create!(username: "s_smitty", password: "password", name: "Sam Smith", email: "sam_smithy@yahooey.com")
    @admin = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com", role: 1)

    visit root_path
  end
  
  it "When I log in as an admin user, I'm taken to my admin dashboard '/admin/dashboard'" do
    visit login_path

    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password

    click_on "Log In" 

    expect(current_path).to eq(admin_dashboard_index_path)
  end

  it "When at my admin dashboard, I see a list of links of all default users' email adresses" do
    visit login_path

    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    
    click_on "Log In" 

    within(".users") do 
      expect(page).to have_content("Existing Users")
      expect(page).to have_link("#{@user_1.email}")
      expect(page).to have_link("#{@user_2.email}")
      expect(page).to have_link("#{@admin.email}")
    end
  end

  it "When I click on a default user's email, I am taken to the admin dashboard 'admin/users/:id where I see the same dashboard that particular user would'" do
    visit login_path

    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    
    click_on "Log In"

    within(".users") do 
      click_link("#{@user_1.email}")
    end

    expect(page).to have_content("#{@user_1.name}'s Dashboard")
  end

  xit "takes me to my dashboard when I am logged in." do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"

    expect(current_path).to eq(dashboard_path)
    
    expect(page).to have_content("Welcome, #{user.username}!")
    
    visit root_path

    click_on "#{user.email}"

    expect(current_path).to eq(dashboard_path)

  end

  xit "cannot log in with bad credentials" do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: "incorrect password"

    click_on "Log In"

    expect(current_path).to eq(login_path)

    expect(page).to have_content("Sorry, your credentials are bad.")
  end

  xit "cannot log in with bad credentials 2" do
    user = User.create(username: "funbucket13", password: "test", name: "Funbucket", email: "f_bucket@google.com")

    visit login_path

    fill_in :email, with: "invalid"
    fill_in :password, with: "test"

    click_on "Log In"

    expect(current_path).to eq(login_path)

    expect(page).to have_content("Sorry, your email does not exist as a user.")
  end
end