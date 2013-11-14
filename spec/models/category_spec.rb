require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do
    it "returns an array of six videos if there are six videos" do
      comedy = Category.create(name: "Comedy")
      videos = []
      (1..6).each do |i|
        videos << Video.create(title: "Movie #{i}", description: "Description #{i}.", category: comedy)
      end
      expect(comedy.recent_videos.count).to eq(6)
    end
    
    it "returns an array of six videos more than six videos" do
      comedy = Category.create(name: "Comedy")
      videos = []
      (1..7).each do |i|
        videos << Video.create(title: "Movie #{i}", description: "Description #{i}.", category: comedy)
      end
      expect(comedy.recent_videos.count).to eq(6)
    end
    it "returns all the video if there are less than six videos" do
      comedy = Category.create(name: "Comedy")
      videos = []
      (1..5).each do |i|
        videos << Video.create(title: "Movie #{i}", description: "Description #{i}.", category: comedy)
      end
      expect(comedy.recent_videos.count).to eq(5)
    end
    it "returns the videos in decending order of created_at" do
      comedy = Category.create(name: "Comedy")
      ghost_busters = Video.create(title: "Ghost Busters", description: "Ghost Movie.", category: comedy)
      gooneys = Video.create(title: "Gooneys", description: "Adventure movie.", category: comedy, created_at: 1.day.ago)
      expect(comedy.recent_videos).to eq([ghost_busters, gooneys])
    end
    it "returns the most recent videos" do
      comedy = Category.create(name: "Comedy")
      videos = []
      (1..6).each do |i|
        videos << Video.create(title: "Movie #{i}", description: "Description #{i}.", category: comedy)
      end
      last_video = Video.create(title: "last movie", description: "This is the last movie created.", category: comedy, created_at: 1.day.ago)
      expect(comedy.recent_videos).not_to include(last_video)
    end
    it "returns on empty array when there are no videos" do
      comedy = Category.create(name: "Comedy")
      expect(comedy.recent_videos).to eq([])
    end
  end
end