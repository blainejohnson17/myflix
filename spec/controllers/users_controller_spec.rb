require 'spec_helper'

describe UsersController do
  describe "GET #new" do
    it "assigns new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do

    context "with valid attributes" do

      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "saves new user to the database" do
        expect(User.count).to eq(1)
      end

      it "logs new user in" do
        expect(session[:user_id]).to eq(User.first.id)
      end

      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank        
      end

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid attributes" do

      before do
        post :create, user: Fabricate.attributes_for(:user, email: nil)
      end

      it "doesn't save new user to the database" do
        expect(User.count).to eq(0)
      end

      it "renders :new template" do
        expect(response).to render_template :new
      end

      it "assigns new User to @user with params" do
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
end