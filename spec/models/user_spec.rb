require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should have_many(:queue_items).order(:position).dependent(:destroy) }
  it { should have_many(:reviews).order('created_at DESC').dependent(:destroy) }
  it { should have_secure_password }

  describe "#queued_video?" do

    it "should return true when the video is in the users queue" do
      current_user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: current_user, video: video)
      expect(current_user.queued_video?(video)).to eq(true)
    end

    it "should return false when the video is not in the users queue" do
      current_user = Fabricate(:user)
      expect(current_user.queued_video?(Fabricate(:video))).to eq(false)
    end
  end
end