require "rails_helper"

RSpec.describe "Dashboard Page" do 
  before(:each) do 
    @user_1 = User.create!(username: "j_smitty", password: "1234", name: "Joe Smith", email: "joey_smithy@yahooey.com")
    @user_2 = User.create!(username: "s_smitty", password: "password", name: "Sam Smith", email: "sam_smithy@yahooey.com")
    @user_3 = User.create!(username: "i_smitty", password: "test", name: "Isaac Smith", email: "isaac_smithy@yahooey.com")
    @user_4 = User.create!(username: "k_smitty", password: "4321", name: "Kara Smith", email: "kara_smithy@yahooey.com")

    @viewing_party_1 = ViewingParty.create!(duration_of_party: 300, when: "2023-12-25", start_time: "10:10 AM", movie_id: 238 )
    @viewing_party_2 = ViewingParty.create!(duration_of_party: 280, when: "2439-10-31", start_time: "11:48 AM", movie_id: 278)
    @viewing_party_3 = ViewingParty.create!(duration_of_party: 400, when: "2455-7-31", start_time: "12:25 PM", movie_id: 155)
    @viewing_party_4 = ViewingParty.create!(duration_of_party: 450, when: "2467-10-31", start_time: "10:30 PM", movie_id: 497)
    @viewing_party_5 = ViewingParty.create!(duration_of_party: 425, when: "2439-9-25", start_time: "9:00 PM", movie_id: 13)

    @user_1.viewing_party_users.create!(viewing_party: @viewing_party_1, is_host: false)
    @user_1.viewing_party_users.create!(viewing_party: @viewing_party_2, is_host: true)
    @user_1.viewing_party_users.create!(viewing_party: @viewing_party_3, is_host: false)
    @user_1.viewing_party_users.create!(viewing_party: @viewing_party_4, is_host: true)

    @user_2.viewing_party_users.create!(viewing_party: @viewing_party_1, is_host: true)
    @user_2.viewing_party_users.create!(viewing_party: @viewing_party_3, is_host: true)
    @user_2.viewing_party_users.create!(viewing_party: @viewing_party_2, is_host: false)

    @user_3.viewing_party_users.create!(viewing_party: @viewing_party_1, is_host: false)

    @user_4.viewing_party_users.create!(viewing_party: @viewing_party_1, is_host: false)

    visit user_path(@user_1)
  end

  describe "when visiting the user's dashboard", :vcr do 
    it "I should see my name in possesive of dashboard" do 
      expect(page).to have_content("#{@user_1.name}'s Dashboard")
    end

    it "And has a button to discover movies" do 
      expect(page).to have_button("Discover Movies")
    end

    it "And has a section that lists viewing parties" do 
      within(".viewing_parties") do
        expect(page).to have_content("25/12/2023")
        expect(page).to have_content("10:10 AM")
        expect(page).to have_content("31/10/2439")
        expect(page).to have_content("11:48 AM")
      end
    end

    it "Redirects to the discover page after clicking 'Discover Movies'" do
      click_button "Discover Movies"
      
      expect(current_path).to eq("/users/#{@user_1.id}/discover")
    end

    it "Has the viewing parties the user was invited to" do 
       within(".viewing_parties") do
        expect(page).to have_content("25/12/2023")
        expect(page).to have_content("31/10/2439")
        expect(page).to have_content("31/07/2455")
        expect(page).to have_content("31/10/2467")
        expect(page).to_not have_content("25/09/2439")
      end
    end

    it "has the image to the movie the user is invited to" do 
      expect(find(".movie_238")[:src]).to eq("https://image.tmdb.org/t/p/w500//9Baumh5J9N1nJUYzNkm0xsgjpwY.jpg")
    end

    it "has the movie title the user is invited to" do 
      within(".invited_parties") do
        expect(page).to have_link("The Godfather")
        expect(page).to have_link("The Dark Knight")
        expect(page).to_not have_link("Shawshank Redemption")
        click_link "The Godfather"
      end
       expect(current_path).to eq("/users/#{@user_1.id}/movies/#{238}")
    end

    it "has date and time of event for the parties the user was invited to" do 
      within(".invited_parties") do 
        expect(page).to have_content("25/12/2023")
        expect(page).to have_content("31/07/2455")
        expect(page).to_not have_content("31/10/2439")
        expect(page).to have_content("10:10 AM")
        expect(page).to_not have_content("11:48 AM")
      end
    end

    it "has the name of the host of the party" do 
       within(".invited_parties") do 
        expect(page).to have_content("Host: Sam Smith", count: 2)
        expect(page).to_not have_content("Host: Joe Smith")
      end
    end

     it "has the name the users invited to the party with my name in bold" do 
      
       within(".party_#{@viewing_party_1.id}_guests") do 
        expect(page).to have_content("Joe Smith")
        expect(page).to have_content("Kara Smith")
        expect(page).to have_content("Isaac Smith")
        expect(page).to have_css('p b', text: 'Joe Smith')
        expect(page).to_not have_content("Sam Smith")
      end
    end
#-----------------------------

    it "has the image to the movie the user is hosting" do 
      expect(find(".movie_278")[:src]).to eq("https://image.tmdb.org/t/p/w500/") 
    end

    it "has the movie title the user is hosting" do 
      within(".hosting") do
        expect(page).to have_link("Shawshank Redemption")
        expect(page).to have_link("The Green Mile")
        expect(page).to_not have_link("The Godfather")
        click_link "Shawshank Redemption"
      end
       expect(current_path).to eq("/users/#{@user_1.id}/movies/#{278}")
    end

    it "has date and time of event for the parties the user is hosting" do 
      within(".hosting") do 
        expect(page).to_not have_content("25/12/2023")
        expect(page).to_not have_content("31/07/2455")
        expect(page).to have_content("31/10/2439")
        expect(page).to_not have_content("10:10 AM")
        expect(page).to have_content("11:48 AM")
      end
    end

    it "has the name of the host of the party" do 
       within(".hosting") do 
        expect(page).to have_content("Host: Joe Smith", count: 2)
        expect(page).to_not have_content("Host: Sam Smith")
      end
    end

    it "has the name the users invited to the party" do 
      
       within(".party_#{@viewing_party_2.id}_guests") do 
        expect(page).to have_content("Sam Smith")
        expect(page).to_not have_content("Joe Smith")
      end
    end
  end
end