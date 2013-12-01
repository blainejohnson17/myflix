require 'spec_helper' 

describe RelationshipsController do

  describe "GET #index" do

    it "sets @relationships to current users following relationships" do
      set_current_user
      relationship = Fabricate(:relationship, leader: Fabricate(:user), follower: current_user)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE #destroy" do

    before { set_current_user }

    it "redirects to the people page" do
      relationship = Fabricate(:relationship, leader: Fabricate(:user), follower: current_user)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it "destroys the current users following relationship" do
      relationship = Fabricate(:relationship, leader: Fabricate(:user), follower: current_user)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end

    it "does not destroy other users following relationships" do
      other_user = Fabricate(:user)
      leader = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: leader, follower: other_user)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end
end