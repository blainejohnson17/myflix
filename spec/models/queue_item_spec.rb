require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: 'Gooneys')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Gooneys")
    end
  end

  describe "#rating" do
    it "returns the rating of the associated video created by the current_user" do
      current_user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: current_user, video: video, rating: 5)
      queue_item = Fabricate(:queue_item, user: current_user, video: video)
      expect(queue_item.rating).to eq(5)
    end
    it "returns nil when the current_user has not rated the associated video" do
      current_user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: current_user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#category_name" do
    it "return the category name of the associated video" do
      category = Fabricate(:category, name: 'Comedy')
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq('Comedy')
    end
  end

  describe "#category" do
    it "returns the category object associated with the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)      
    end
  end
end