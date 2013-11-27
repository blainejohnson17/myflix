require 'spec_helper'

describe VideosController do

  before { set_current_user }

  describe "GET #show" do

    let(:video) { Fabricate(:video) }

    it "assigns the requested video to @video"  do
      get :show, id: video
      expect(assigns(:video)).to eq(video)
    end

    it "assigns the reviews for the requested video to @reviews" do
      review1 = Fabricate(:review, video: video, user: Fabricate(:user))
      review2 = Fabricate(:review, video: video, user: Fabricate(:user))
      get :show, id: video
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 1 }
    end
  end

  describe "GET #search" do

    it "assigns the results of search to @videos" do
      goonies = Fabricate(:video, title: 'Goonies')
      get :search, term: 'go'
      expect(assigns(:videos)).to eq([goonies])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :search, term: 'go' }
    end
  end
end