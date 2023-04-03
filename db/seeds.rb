# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all
ViewingParty.destroy_all
ViewingPartyUser.destroy_all

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