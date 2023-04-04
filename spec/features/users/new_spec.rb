require "rails_helper"

RSpec.describe "Registration Page" do 
  before(:each) do 
    visit "/register"
  end

  describe "when visiting  '/register' " do 
    it "should have a form with name, email, and a register button" do 
      within(".register_user") do
        expect(page).to have_field(:name)
        expect(page).to have_field(:email)
        expect(page).to have_button("Create New User")
      end
    end

    it "Once the user registers they should be taken to their dashboard" do 
      within(".register_user") do
        fill_in(:username, with: "bob")
        fill_in(:name, with: "Bob")
        fill_in(:email, with: "bob@builder.com")
        fill_in(:password, with: "whateveah")
        fill_in(:password_confirmation, with: "whateveah")
        click_button("Create New User")
      end

      user = User.last

      expect(current_path).to eq(user_path(user))
    end

    it "Get an error message and return to '/register' with no new user created" do 
      within(".register_user") do
        fill_in(:name, with: '')
        fill_in(:email, with: "not_a_real_email@napster.com")
        click_button("Create New User")
      end

      user = User.last

      expect(current_path).to eq("/register")
      expect(user).to eq(nil)
      expect(page).to have_content("Username can't be blank, Password can't be blank, Name can't be blank")
    end

    it "Get an error message and return to '/register' when password and password_confirmation don't match" do 
      within(".register_user") do
        fill_in(:username, with: "bob")
        fill_in(:name, with: "Bob")
        fill_in(:email, with: "bob@builder.com")
        fill_in(:password, with: "whateveah")
        fill_in(:password_confirmation, with: "whatever")
        click_button("Create New User")
      end

      user = User.last

      expect(current_path).to eq("/register")
      expect(user).to eq(nil)
      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    it "Get an error message and return to '/register' when a second user is made that is using an email that already exists and isn't made" do 
      user_1 = User.create!(username: "bob", password: "bob", name: "Bob", email: "bob@builder.com")
      
      within(".register_user") do
        fill_in(:name, with: "Rob")
        fill_in(:email, with: "bob@builder.com")
        click_button("Create New User")
      end

      user_2 = User.last

      expect(current_path).to eq("/register")
      expect(User.count).to eq(1)
      expect(User.count).to_not eq(2)
      expect(user_2.email).to eq("bob@builder.com")
      expect(user_2.name).to eq("Bob")
      expect(user_2.name).to_not eq("Rob")
      expect(user_2).to eq(user_1)
      expect(page).to have_content("Username can't be blank, Password can't be blank, Email has already been taken")
    end
  end
end