require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  include SessionsHelper
  describe "GET #new" do
    it 'renders the login page' do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do

    context 'when login is valid' do
      before :each do
        @usr = FactoryGirl.create(:user)
        post :create, session:{username: attributes_for(:user)[:username], 
                               password: attributes_for(:user)[:password],
                               email:    attributes_for(:user)[:email]}
      end
      after :each do
        @usr = nil
        logout
      end
      it "sets the user in the session" do
        expect(current_user!).to eq(@usr)
      end
      it 'redirects to the users show page' do
        expect(response).to redirect_to(user_path(@usr))
      end
    end

    context 'when login is invalid' do
      before :each do
        post :create, session:{username: attributes_for(:user)[:username], 
                               password: "invalid",
                               email:    attributes_for(:user)[:email]}
      end
      it "re-serves #new" do
        expect(response).to render_template("new")
      end
      it "provides errors" do
        expect(flash[:errors]).to eq(["invalid username-password combination"])
      end
      it "provides username data" do
        expect(flash[:data]).to eq({username: attributes_for(:user)[:username]})
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do 
      login(FactoryGirl.create(:user)) 
      delete :destroy, id:1
    end
    after  :each do logout end

    it "clears the session" do
      expect(current_user).to be nil
    end
    it "redirects to new session path" do
      expect(response).to redirect_to(new_session_path)
    end
  end
end