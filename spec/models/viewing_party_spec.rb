require "rails_helper"

RSpec.describe ViewingParty do 
  before(:each) do 
    @user_1 = User.create!(username: "j_smitty", password: "1234", name: "Joe Smith", email: "joey_smithy@yahooey.com")
    @user_2 = User.create!(username: "s_smitty", password: "password", name: "Sam Smith", email: "sam_smithy@yahooey.com")
    @user_3 = User.create!(username: "s_saaaaa", password: "5879", name: "Sam Saaaaa", email: "sam_saaaaa@yahooey.com")

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
    @user_3.viewing_party_users.create!(viewing_party: @viewing_party_1, is_host: false)
    
  end

  describe "relationships" do 
    it {should have_many :users}
    it {should have_many(:users).through(:viewing_party_users)}
  end

  describe "validations" do 
    it {should validate_presence_of :duration_of_party}
    it {should validate_presence_of :start_time}
    it {should validate_presence_of :when}
    it {should validate_presence_of :movie_id}
  end

  describe "party_host" do 
    it "is the host of the viewing party" do 
      expect(@viewing_party_1.party_host).to eq(@user_2)
    end
  end

  describe "users_invited" do 
    it "is a list of users invited to the party" do 
      expect(@viewing_party_1.users_invited).to eq([@user_1, @user_3])
    end
  end
end