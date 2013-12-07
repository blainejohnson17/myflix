require 'spec_helper'

feature "User follows another user" do

  given(:comedy) { Fabricate(:category) }
  given(:gooneys) { Fabricate(:video, title: "Gooneys", category: comedy) }
  given(:bob) { Fabricate(:user) }

  background do
    sign_in
    Fabricate(:review, video: gooneys, user: bob)
  end

  scenario "user follows and unfollows another user" do

    click_video_on_home_page(gooneys)

    click_link bob.full_name

    click_link "Follow"

    within("section.people") do
      expect(page).to have_content(bob.full_name)
    end

    find("a[href='/relationships/1']").click

    within("section.people") do
      expect(page).not_to have_content(bob.full_name)
    end
  end
end