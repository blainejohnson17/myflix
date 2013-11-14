require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search_by_title" do

    it "returns an empty array if no match is found" do
      gooneys = Video.create(title: "Gooneys", description: "Adventure movie.")
      ghost_busters = Video.create(title: "Ghost Busters", description: "Ghost Movie.")
      expect(Video.search_by_title("Monk")).to eq([])
    end

    it "returns an array of one video for a single exact match" do
      gooneys = Video.create(title: "Gooneys", description: "Adventure movie.")
      ghost_busters = Video.create(title: "Ghost Busters", description: "Ghost Movie.")
      expect(Video.search_by_title("Gooneys")).to eq([gooneys])
    end

    it "returns an array of one video for a single partial match" do
      gooneys = Video.create(title: "Gooneys", description: "Adventure movie.")
      ghost_busters = Video.create(title: "Ghost Busters", description: "Ghost Movie.")
      expect(Video.search_by_title("Goon")).to eq([gooneys])
    end

    it "returns an array of multiple videos for multple parital matches ordered by created_at desc" do
      gooneys = Video.create(title: "Gooneys", description: "Adventure movie.", created_at: 1.day.ago)
      ghost_busters = Video.create(title: "Ghost Busters", description: "Ghost Movie.")
      expect(Video.search_by_title("G")).to eq([ghost_busters, gooneys])
    end

    it "returns an empty array for a search of an empty string" do
      gooneys = Video.create(title: "Gooneys", description: "Adventure movie.", created_at: 1.day.ago)
      ghost_busters = Video.create(title: "Ghost Busters", description: "Ghost Movie.")
      expect(Video.search_by_title("")).to eq([])
    end

    it "returns an empty string if search term only contains white space" do
      gooneys = Video.create(title: "Gooneys", description: "Adventure movie.", created_at: 1.day.ago)
      ghost_busters = Video.create(title: "Ghost Busters", description: "Ghost Movie.")
      expect(Video.search_by_title(" ")).to eq([])
      expect(Video.search_by_title("  ")).to eq([])
    end
  end

  describe "#average_rating" do

    before do
      @video = Fabricate(:video)
    end

    it "returns 0 if there are no ratings" do
      expect(@video.average_rating).to eq(0)
    end

    it "returns the rating when there is 1 review" do
      review = Fabricate(:review, video: @video)
      expect(@video.average_rating).to eq(review.rating)
    end

    it "returns the average of all ratings when there are more than one reviews" do
      Fabricate(:review, video: @video, rating: 2)
      Fabricate(:review, video: @video, rating: 3)
      expect(@video.average_rating).to eq((2 + 3)/2.0)
    end

    it "returns the average with up to 2 decimal places of precision" do
      Fabricate(:review, video: @video, rating: 1)
      Fabricate(:review, video: @video, rating: 1)
      Fabricate(:review, video: @video, rating: 2)
      expect(@video.average_rating).to eq(1.33)
    end
  end
end