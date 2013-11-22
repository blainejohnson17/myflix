require 'spec_helper'

describe QueueItemsController do

  describe "GET #index" do

    context "with authenticated user" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      it "assigns all queue_items to @queue_items for authenticated user" do
        queue_item1 = Fabricate(:queue_item, user: current_user)
        queue_item2 = Fabricate(:queue_item, user: current_user)
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end

      it "orders queue_items with position" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 2)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 1)
        get :index
        expect(assigns(:queue_items)).to eq([queue_item2, queue_item1])
      end
    end

    context "with unauthenticated user" do
  
      it "redirects to sign in page for unauthenticated users" do
        get :index
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST #create" do

    context "with authenticated user" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      it "redirects to the my queue page" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it "saves new queue item to the database" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it "creates new queue item associated to the video with id in params" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it "creates new queue item associated with the signed in user" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(current_user)
      end

      it "creates new queue item as in last position" do
        gooneys = Fabricate(:video)
        Fabricate(:queue_item, user: current_user, video: gooneys)
        ghost_busters = Fabricate(:video)
        post :create, video_id: ghost_busters.id
        ghost_busters_queue_item = QueueItem.where(video_id: ghost_busters.id, user_id: current_user.id).first
        expect(ghost_busters_queue_item.position).to eq(2)
      end

      it "does not create new queue item if queue item already exists for that video and user" do
        gooneys = Fabricate(:video)
        Fabricate(:queue_item, user: current_user, video: gooneys)
        post :create, video_id: gooneys.id
        expect(current_user.queue_items.count).to eq(1)
      end
    end

    context "with unauthenticated user" do

      it "redirects to sign in page" do
        post :create, video_id: 1
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "DELETE #destroy" do

    context "with authenticated user" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      it "redirects to my_queue page" do
        queue_item = Fabricate(:queue_item, user: current_user)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes queue item" do
        queue_item = Fabricate(:queue_item, user: current_user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "doesn't delete queue item if queue item is not in the current users queue" do        
        other_user = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: other_user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end

      it "normalizes the remaining queue_items" do
        queue_item1 = Fabricate(:queue_item, position: 1, user: current_user)
        queue_item2 = Fabricate(:queue_item, position: 2, user: current_user)
        delete :destroy, id: queue_item1.id
        expect(QueueItem.first.position).to eq(1)
      end
    end

    context "with unauthenticated user" do

      it "redirects to sign in page" do
        delete :destroy, id: 1
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST #update_queue" do

    context "with authenticated user" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      context "with complete input" do
        
        it "redirects to my queue page" do
          queue_item1 = Fabricate(:queue_item, position: 1, user: current_user)
          queue_item2 = Fabricate(:queue_item, position: 2, user: current_user)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          expect(response).to redirect_to my_queue_path
        end

        it "updates position of all queue items in users queue" do
          queue_item1 = Fabricate(:queue_item, position: 1, user: current_user)
          queue_item2 = Fabricate(:queue_item, position: 2, user: current_user)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          expect(queue_item1.reload.position).to eq(2)
          expect(queue_item2.reload.position).to eq(1)
        end

        it "normalizes all queue_item positions in users queue" do
          queue_item1 = Fabricate(:queue_item, position: 1, user: current_user)
          queue_item2 = Fabricate(:queue_item, position: 2, user: current_user)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1}]
          expect(queue_item1.reload.position).to eq(2)
          expect(queue_item2.reload.position).to eq(1)
        end
      end

      context "with incomplete input" do

        it "redirects to my queue page" do
          queue_item1 = Fabricate(:queue_item, position: 1, user: current_user)
          queue_item2 = Fabricate(:queue_item, position: 2, user: current_user)
          post :update_queue, queue_items: [{id: queue_item2.id, position: 1}]
          expect(response).to redirect_to my_queue_path
        end

        it "doesn't update any queue_items" do
          queue_item1 = Fabricate(:queue_item, position: 1, user: current_user)
          queue_item2 = Fabricate(:queue_item, position: 2, user: current_user)
          post :update_queue, queue_items: [{id: queue_item2.id, position: 1}]
          expect(queue_item1.reload.position).to eq(1)
          expect(queue_item2.reload.position).to eq(2)
        end
      end

      context "with queue_items from another users queue" do

        it "redirects to my queue page" do
          other_user = Fabricate(:user)
          queue_item1 = Fabricate(:queue_item, position: 1, user: current_user)
          queue_item2 = Fabricate(:queue_item, position: 2, user: other_user)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          expect(response).to redirect_to my_queue_path
        end

        it "doesn't change any of the queue_items" do
          other_user = Fabricate(:user)
          queue_item1 = Fabricate(:queue_item, position: 1, user: current_user)
          queue_item2 = Fabricate(:queue_item, position: 2, user: other_user)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          expect(queue_item1.reload.position).to eq(1)
          expect(queue_item2.reload.position).to eq(2)
        end
      end
    end

    context "with unauthenticated user" do

      it "redirects to sign in page" do
        post :update_queue, queue_items: [{id: 1, position: 2}, {id: 2, position: 1}]
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end