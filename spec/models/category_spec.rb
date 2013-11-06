require 'spec_helper'

describe Category do 
  it "saves itself" do
    category = Category.new(name: "Comedy")
    category.save
    expect(Category.first).to eq(category)
  end

  it "has many videos" do
    comedy = Category.create(name: "Comedy")
    gooneys = Video.create(title: "Gooneys", description: "Pirate Movie", categories: [comedy])
    space_balls = Video.create(title: "Space Balls", description: "Space Movie", categories: [comedy])
    expect(comedy.videos).to eq([gooneys, space_balls])
  end

  it "does not save a category without a name" do
    category = Category.create()
    expect(Category.count).to eq(0)
  end
end