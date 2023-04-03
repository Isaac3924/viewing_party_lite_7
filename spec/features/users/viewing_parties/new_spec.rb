require "rails_helper"

RSpec.describe "New Viewing Party Page" do 
  before(:each) do 
    @user_1 = User.create!(username: "j_smitty", password: "1234", name: "Joe Smith", email: "joey_smithy@yahooey.com")
    @user_2 = User.create!(username: "s_smitty", password: "password", name: "Sam Smith", email: "sam_smithy@yahooey.com")
    @user_3 = User.create!(username: "j_doe", password: "9876", name: "Jane Doe", email: "jane_doe@yahooey.com")

    visit "/users/#{@user_2.id}/movies/238/viewing_party/new" 
  end

  describe "when visiting the new viewing party page ", :vcr do 
    it "should have the name of the movie" do 
      
      expect(page).to have_content("The Godfather")
    end
    
    it "Has a form to create a new viewing party" do 
      within(".new_party") do
        expect(page).to have_field(:duration_of_party, with: 175)
        expect(page).to have_field(:when)
        expect(page).to have_field(:start_time)
        expect(page).to have_unchecked_field("users_#{@user_1.id}")
        expect(page).to_not have_unchecked_field("users_#{@user_2.id}")
        expect(page).to have_unchecked_field("users_#{@user_3.id}")
        expect(page).to have_button("Create Party")
      end
    end

    it "Can create a new viewing party" do 
      within(".new_party") do
        fill_in(:when, with: Date.today)
        fill_in(:start_time, with: "04:30 PM")
        check "users_#{@user_1.id}"
        click_button("Create Party")
      end
      
      viewing_party = ViewingParty.last

      fill_in :email, with: @user_2.email
      fill_in :password, with: @user_2.password

      click_on "Log In"
      expect(current_path).to eq(user_path(@user_2))
      expect(ViewingParty.count).to eq(1)
      expect(ViewingPartyUser.count).to eq(2)
      expect(page).to have_content(viewing_party.when.to_date.strftime("%d/%m/%Y"))
    end

    it "Get an error message and return to the new viewing part page when the duration of the party is less than the duration of the film" do 
      
      within(".new_party") do
        fill_in(:duration_of_party, with: 175)
        fill_in(:start_time, with: "04:30 PM")
        check "users_#{@user_1.id}"
        click_button("Create Party")
      end

      expect(current_path).to eq("/users/#{@user_2.id}/movies/238/viewing_party/new")
      expect(ViewingParty.count).to eq(0)
      expect(ViewingParty.count).to_not eq(1)
      expect(ViewingPartyUser.count).to eq(0)
      expect(ViewingPartyUser.count).to_not eq(2)
      expect(page).to have_content("Error: Invalid form entry")
    end
  end
end