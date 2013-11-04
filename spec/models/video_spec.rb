require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video. new(title: 'Gooneys', description: 'Movie about kids, pirates and treasure')
    video.save
    Video.first.title.should == 'Gooneys'
    Video.first.description.should == 'Movie about kids, pirates and treasure'
  end
end