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
end