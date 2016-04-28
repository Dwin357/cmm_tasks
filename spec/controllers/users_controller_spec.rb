require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include SessionsHelper

  context 'when not logged in' do
    describe "GET #new" do
      it 'renders new user page' do
        get :new
        expect(response).to render_template(:new)
      end
    end
    describe "POST #create" do
      context "with valid model params" do
        after :each do logout end
        it "saves new user in db" do
          expect{
            post :create, user: FactoryGirl.attributes_for(:user)
          }.to change(User, :count).by(1)
        end
        it "logs in new user" do
          post :create, user: FactoryGirl.attributes_for(:user)
          expect(User.last).to eq(current_user!)
        end
        it "redirects to user show page" do
          # db only has 1 entry, so User.first also works
          post :create, user: FactoryGirl.attributes_for(:user)
          expect(response).to redirect_to(user_path(User.last))
        end 
      end
      # #no validations, not possible to have "invalid" model params
      # context "with not valid model params"
      #   it "re-renders new template" do
      #     post :create, user: #bad user model
      #     expect(response).to render_template(:new)
      #   end
      #   it "populates errors flash" do
      #     post :create, user: #bad user model
      #     expect(flash[:errors]).to eq(["error message"])
      #   end
      #   it "provides populated user model" do
      #     post :create, user: #bad user model
      #     expect(@user).to eq(#bad user model)
      #   end
      # end
    end
    describe "GET #edit" do
      it "redirects to new session path" do
        # the controller doesn't need the id, this is just to trick RSpec into the right route
        get :edit, id:1
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe "GET #show" do
      it "redirects to new session path" do
        get :show, id:1
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe "POST #update" do
      it "redirects to new session path" do
        post :update, id:1
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe "DELETE #destroy" do
      it "redirects to new session path" do
        delete :destroy, id:1
        expect(response).to redirect_to(new_session_path)
      end
    end
  end


  context 'when logged in' do
    before :each do login(FactoryGirl.create(:user)) end
    after  :each do logout end

    describe "GET #edit" do
      context "with valid edit permissions" do
        it "serves edit page" do
          get :edit, id: current_user.id
          expect(response).to render_template(:edit)
        end
        it "populates user model" do
          get :edit, id: current_user.id
          expect(assigns(:user)).to eq(current_user)
        end
      end
      # #currently edit permissions compares current_user w/ user_from params 
      # #since these are parallel processes, it is always valid 
      # context "with invalid edit permissions"
      #   it "renders show template" do
      #     post :create, user: #bad edit permissions
      #     expect(response).to render_template(:show)
      #   end
      #   it "populates errors flash" do
      #     post :create, user: #bad edit permissions
      #     expect(flash[:errors]).to eq(["error message"])
      #   end
      #   it "provides populated user model of current user" do
      #     post :create, user: #bad edit permissions
      #     expect(@user).to eq(current_user)
      #   end
      # end
    end
    describe "POST #update" do
      before :each do
        @sbj        = current_user!
        @comparison = FactoryGirl.build(:alt_user)
      end
      after :each do
        @sbj        = nil
        @comparison = nil
      end
      context "with valid edit permissions" do
        context "with valid model params" do
          it "locates the correct user" do
            put :update, id: @sbj, user: FactoryGirl.attributes_for(:alt_user)
            expect(assigns(:user)).to eq(@sbj)
          end
          it "updates model attributes" do
            put :update, id: @sbj, user: FactoryGirl.attributes_for(:alt_user)
            @sbj.reload
            expect(@sbj.username).to eq(@comparison.username)
            expect(@sbj.email).to eq(@comparison.email)
          end
          it "redirects to user show" do
            put :update, id: @sbj, user: FactoryGirl.attributes_for(:alt_user)
            expect(response).to redirect_to(user_path(@sbj))
          end 
        end
        # #no validations, not possible to have "invalid" model params
        # context "with invalid model params"
        #   it "re-renders edit template" do
        #     post :update, user: #bad user model
        #     expect(response).to render_template(:edit)
        #   end
        #   it "populates errors flash" do
        #     post :update, user: #bad user model
        #     expect(flash[:errors]).to eq(["error message"])
        #   end
        #   it "provides populated user model" do
        #     post :update, user: #bad user model
        #     expect(@user).to eq(#bad user model)
        #   end
        # end
      end
      # #currently edit permissions compares current_user w/ user_from params 
      # #since these are parallel processes, it is always valid 
      # context "with invalid edit permissions"
      #   it "renders show template" do
      #     post :update, user: #bad edit permissions
      #     expect(response).to render_template(:show)
      #   end
      #   it "populates errors flash" do
      #     post :update, user: #bad edit permissions
      #     expect(flash[:errors]).to eq(["error message"])
      #   end
      #   it "provides populated user model of current user" do
      #     post :update, user: #bad edit permissions
      #     expect(@user).to eq(current_user)
      #   end
      # end
    end


    describe "DELETE #destroy" do
      context "with valid destroy permissions" do
        it "removes the record from db" do
          expect{
            delete :destroy, id: current_user
          }.to change(User, :count).by(-1)
        end
        it "clears user session" do
          delete :destroy, id: current_user
          expect(session[:user_id]).to be nil
        end
        it "redirects to new session path" do
          delete :destroy, id: current_user
          expect(response).to redirect_to(root_path)
        end
      end
      # context "with invalid destroy permissions"
      # #currently destroy permissions compares current_user w/ user_from params 
      # #since these are parallel processes, it is always valid      
    end  


    describe "GET #show" do
      it "renders show page" do
        get :show, id:current_user
        expect(response).to render_template(:show)
      end
      it "assigns users tasks" do
        expected = current_user.tasks
        get :show, id:current_user
        expect(assigns(:tasks)).to eq(expected)
        expect(assigns(:user)).to eq(current_user)
      end
    end
  end
end