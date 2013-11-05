require 'spec_helper'

describe Category do 
  it "saves itself" do
    category = Category.new(name: 'Comedy')
    category.save
    Category.first.name.should == 'Comedy'
  end

  it "has many videos" do
    category = Category.create(name: 'TV')
    
    (1..10).each do |i|
      category.videos << Video.create(title: "Movie#{i}", description: "Movie description #{i}")
    end
    category.videos.count.should == 10
  end
end