require 'spec_helper'

describe Video do
  it "saves itself" do
    gooneys = Video. new(title: 'Gooneys', description: 'Movie about kids, pirates and treasure')
    gooneys.save
    expect(Video.first).to eq(gooneys)
  end

  it "has many categories" do
    gooneys = Video.create(title: "Gooneys", description: "Pirate Movie")
    action = Category.create(name: "action", videos: [gooneys])
    comedy = Category.create(name: "comedy", videos: [gooneys])
    expect(gooneys.categories).to eq([action, comedy])
  end
end