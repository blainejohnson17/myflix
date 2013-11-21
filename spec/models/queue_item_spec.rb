require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }
  it { should validate_numericality_of(:position).only_integer }

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

  describe "#rating=" do
    
    context "when a review for the associated video is not present" do

      it "saves a review with the rating when input is 1, 2, 3, 4 or 5" do
        queue_item = Fabricate(:queue_item)
        queue_item.rating = 3
        expect(queue_item.reload.rating).to eq(3)
      end

      it "doesn't create a review when the input is 0" do
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, video: video)
        queue_item.rating = "0"
        expect(video.reviews.count).to eq(0)
      end

      it "creates a new review associated to the video" do
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, video: video)
        queue_item.rating = "3"
        expect(Review.where(video_id: video.id).first.video).to eq(video)
      end

      it "creates a new rating associated to the current_user" do
        current_user = Fabricate(:user)
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: current_user, video: video)
        queue_item.rating = "3"
        expect(Review.where(user_id: current_user.id).first.user).to eq(current_user)
      end
    end

    context "when a review for the associated video is present" do

      it "updates the rating for the review when input is 1, 2, 3, 4 or 5" do
        current_user = Fabricate(:user)
        video = Fabricate(:video)
        review = Fabricate(:review, rating: 1, video: video, user: current_user)
        queue_item = Fabricate(:queue_item, video: video, user: current_user)
        queue_item.rating = "3"
        expect(Review.where(video_id: video).first.rating).to eq(3)
      end
      
      it "removes review when the input is 0" do
        current_user = Fabricate(:user)
        video = Fabricate(:video)
        review = Fabricate(:review, rating: 1, video: video, user: current_user)
        queue_item = Fabricate(:queue_item, video: video, user: current_user)
        queue_item.rating = "0"
        expect(video.reviews.count).to eq(0)
      end
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