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

    follow_user(bob)
    expect_following_user(bob)

    unfollow_user
    expect_unfollow_user(bob)
  end

  def follow_user(user)
    click_link user.full_name
    click_link "Follow"    
  end

  def expect_following_user(user)
    within("section.people") do
      expect(page).to have_content(user.full_name)
    end
  end

  def unfollow_user
    find("a[href='/relationships/1']").click
  end

  def expect_unfollow_user(user)
    within("section.people") do
      expect(page).not_to have_content(user.full_name)
    end
  end

end