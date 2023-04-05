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

    expect(current_path).to eq(admin_user_path(@user_1))

    expect(page).to have_content("#{@user_1.name}'s Dashboard")
  end

  it "As a visitor when I visit any admin routes, I get redirected back to the landing page with a message alerting me to authorization" do
    visit admin_dashboard_index_path

    expect(current_path).to eq(root_path)
    
    expect(page).to have_content("You are not authorized to view this page.")

    visit admin_user_path(@user_1)

    expect(current_path).to eq(root_path)
    
    expect(page).to have_content("You are not authorized to view this page.")
  end

  it "As a default when I visit any admin routes, I get redirected back to the landing page with a message alerting me to authorization" do
    visit login_path

    fill_in :email, with: @user_1.email
    fill_in :password, with: @user_1.password
    
    click_on "Log In"
    
    visit admin_dashboard_index_path

    expect(current_path).to eq(root_path)
    
    expect(page).to have_content("You are not authorized to view this page.")

    visit admin_user_path(@user_1)

    expect(current_path).to eq(root_path)
    
    expect(page).to have_content("You are not authorized to view this page.")
  end
end