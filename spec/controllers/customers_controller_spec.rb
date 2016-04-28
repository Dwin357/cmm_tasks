require 'rails_helper'

RSpec.describe CustomersController, type: :controller do

  context 'when not logged in' do
    describe "GET #new" do
      it "redirects to new session path" do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe "GET #index" do
      it "redirects to new session path" do
        get :index
        expect(response).to redirect_to(new_session_path)
      end
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
  end

  context 'when not logged in' do    
    include SessionsHelper
    before :each do login(FactoryGirl.create(:user)) end
    after :each do logout end

    describe "GET #new" do
      it 'renders new customers page' do
        get :new
        expect(response).to render_template("new")
      end
    end
  end
end