require 'spec_helper'

feature "User interacts with the queue" do

  given(:comedy) { Fabricate(:category) }
  given!(:gooneys) { Fabricate(:video, title: "Gooneys", category: comedy) }
  given!(:ghost_busters) { Fabricate(:video, title: "Ghost Busters", category: comedy) }
  given!(:back_to_the_future) { Fabricate(:video, title: "Back to the Future", category: comedy) }

  background { sign_in }

  scenario "User adds and reorders videos in the queue" do

    add_video_to_queue(gooneys)
    expect(page).to have_content(gooneys.title)

    visit video_path(gooneys)
    expect(page).not_to have_content("+ My Queue")

    add_video_to_queue(ghost_busters)
    add_video_to_queue(back_to_the_future)

    set_queue_item_position(gooneys, 3)
    set_queue_item_position(ghost_busters, 1)
    set_queue_item_position(back_to_the_future, 2)

    click_button "Update Instant Queue"

    expect_queue_item_position(gooneys, 3)
    expect_queue_item_position(ghost_busters, 1)
    expect_queue_item_position(back_to_the_future, 2)
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def set_queue_item_position(video, position)
    within("tr#queue_item_#{video.id}") do
      fill_in "queue_items__position", with: position
    end
  end

  def expect_queue_item_position(video, position)
    expect(find("tr#queue_item_#{video.id} #queue_items__position").value).to eq(position.to_s)
  end
end