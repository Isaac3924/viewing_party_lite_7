require "rails_helper"

RSpec.describe User do 
  before(:each) do 
    @user_1 = User.create!(username: "j_smitty", password: "1234", name: "Joe Smith", email: "joey_smithy@yahooey.com")
    @user_2 = User.create!(username: "s_smitty", password: "password", name: "Sam Smith", email: "sam_smithy@yahooey.com")

    @viewing_party_1 = ViewingParty.create!(duration_of_party: 300, when: "2023-12-25", start_time: "10:10 AM", movie_id: 238 )
    @viewing_party_2 = ViewingParty.create!(duration_of_party: 280, when: "2439-10-31", start_time: "11:48 AM", movie_id: 278)
    @viewing_party_3 = ViewingParty.create!(duration_of_party: 400, when: "2455-7-31", start_time: "12:25 PM", movie_id: 155)
    @viewing_party_4 = ViewingParty.create!(duration_of_party: 450, when: "2467-10-31", start_time: "10:30 PM", movie_id: 497)
    @viewing_party_5 = ViewingParty.create!(duration_of_party: 425, when: "2439-9-25", start_time: "9:00 PM", movie_id: 13)

    @user_1.viewing_party_users.create!(viewing_party: @viewing_party_1, is_host: false)
    @user_1.viewing_party_users.create!(viewing_party: @viewing_party_2, is_host: true)
    @user_1.viewing_party_users.create!(viewing_party: @viewing_party_3, is_host: false)
    @user_1.viewing_party_users.create!(viewing_party: @viewing_party_4, is_host: true)
  end
  describe "relationships" do 
    it {should have_many :viewing_party_users}
    it {should have_many(:viewing_parties).through(:viewing_party_users)}
    it {should validate_presence_of(:username)}
    it {should validate_uniqueness_of(:username)}
    it {should validate_presence_of(:password)}
  end

  describe "validations" do 
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :name}
  end

  describe "movie_ids" do 
    it "is a list of the users viewing party movie ids" do 
      expect(@user_1.movie_ids).to eq([238, 278, 155, 497])
    end
  end

  describe "viewing_parties_invited_to" do 
    it "is the list of viewing parties the user is invited to" do 
      expect(@user_1.viewing_parties_invited_to).to eq([@viewing_party_1, @viewing_party_3])
    end
  end

  describe "viewing_parties_invited_to" do 
    it "is the list of viewing parties the user is invited to" do 
      expect(@user_1.viewing_parties_as_host).to eq([@viewing_party_2, @viewing_party_4])
    end
  end
end