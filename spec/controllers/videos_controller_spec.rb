require 'spec_helper'

describe VideosController do
  describe "GET #show" do
    context "with authenticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
      end

      it "assigns the requested video to @video"  do
        video = Fabricate(:video)
        get :show, id: video
        expect(assigns(:video)).to eq(video)
      end

      it "assigns the reviews for the requested video to @reviews" do
        video = Fabricate(:video)
        review1 = Fabricate(:review, video: video, user: Fabricate(:user))
        review2 = Fabricate(:review, video: video, user: Fabricate(:user))
        get :show, id: video
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end

    context "with unauthenticated user" do
      it "redirects user to sign in page" do
        video = Fabricate(:video)
        get :show, id: video
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "GET #search" do
    context "with authenticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
      end

      it "assigns the results of search to @videos" do
        goonies = Fabricate(:video, title: 'Goonies')
        get :search, term: 'go'
        expect(assigns(:videos)).to eq([goonies])
      end
    end

    context "with unauthenticated user" do
      it "redirects user to sign in page" do
        goonies = Fabricate(:video, title: 'Goonies')
        get :search, term: 'go'
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end