require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video. new(title: 'Gooneys', description: 'Movie about kids, pirates and treasure')
    video.save
    Video.first.title.should == 'Gooneys'
    Video.first.description.should == 'Movie about kids, pirates and treasure'
  end

  it "has many categories" do
    video = Video.create(title: 'Ghost Busters', description: 'Ghost movie')
    
    (1..10).each do |i|
      video.categories << Category.create(name: "Category #{1}")
    end
    video.categories.count.should == 10
  end
end