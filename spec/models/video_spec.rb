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

  it "does not save a video without a title" do
    video = Video.create(description: "Awesome Video!")
    expect(Video.count).to eq(0)
  end

  it "does not save a video without description" do
    video = Video.create(title: "Gooneys")
    expect(Video.count).to eq(0)
  end
end