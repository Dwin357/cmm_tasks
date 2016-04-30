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

  context 'when logged in' do    
    include SessionsHelper
    before :each do login(FactoryGirl.create(:user))end
    after  :each do logout end

    describe "GET #new" do
      it 'renders new customers page' do
        get :new
        expect(response).to render_template("new")
      end
    end

    describe "GET #edit" do
      before :each do
        @cus = FactoryGirl.create(:customer)
      end
      after :each do
        @cus = nil
      end
      it "serves the edit page" do
        get :edit, id: @cus
        expect(response).to render_template(:edit)
      end
      it "populates correct customer model" do
        get :edit, id: @cus
        expect(assigns(:customer)).to eq(@cus)
      end
    end

    describe "GET #show" do
      before :each do
        @cus = FactoryGirl.create(:customer)
      end
      after :each do
        @cus = nil
      end
      it "renders the show page" do
        get :show, id: @cus
        expect(response).to render_template(:show)
      end
      it "populates correct customer model" do
        get :show, id: @cus
        expect(assigns(:customer)).to eq(@cus)
      end
    end

    describe "GET #index" do
      before :each do
        @cstmrs = [FactoryGirl.create(:customer)]
      end
      after :each do
        @cstmrs = nil
      end
      it "renders index page" do
        get :index
        expect(response).to render_template(:index)
      end
      it "assigns all customers" do
        get :index
        expect(assigns(:customers)).to eq(@cstmrs)
      end
    end   

    describe "DELETE #destroy" do
      before :each do
        @cus = FactoryGirl.create(:customer)
      end
      after :each do
        @cus = nil
      end
      it "removes the record from the db" do
        expect{
          delete :destroy, id:@cus
        }.to change(Customer, :count).by(-1)
      end
      it "redirects to current user show pg" do
        delete :destroy, id:@cus
        expect(response).to redirect_to(customers_path)
      end
    end 

    describe "POST #update" do
      context "with valid model params" do
        before :each do
          @sbj = FactoryGirl.create(:customer)
          @comparison = FactoryGirl.build(:alt_customer)          
          @comparison.id = @sbj.id
        end
        after :each do
          @sbj = nil
          @comparison = nil
        end
        it "locates the correct user" do
          put :update, id:@sbj, customer:FactoryGirl.attributes_for(:alt_customer)
          expect(assigns(:customer)).to eq(@sbj)
        end
        it "updates model attributes" do
          put :update, id:@sbj, customer:FactoryGirl.attributes_for(:alt_customer)
          @sbj.reload
          expect(@sbj).to eq(@comparison)
        end
        it "redirects to customer show page" do
          put :update, id:@sbj, customer:FactoryGirl.attributes_for(:alt_customer)
          expect(response).to redirect_to(customer_path(@sbj))
        end
      end
      # context "no model validations yet"
    end

    describe "POST #create" do
      context "with valid model params" do
        it "saves new customer to db" do
          expect{
            post :create, customer: FactoryGirl.attributes_for(:customer)
          }.to change(Customer, :count).by(1)
        end
        it "redirects to new customer's show page" do
          post :create, customer: FactoryGirl.attributes_for(:customer)
          expect(response).to redirect_to(customer_path(Customer.last))
        end
      end
    end
  end
end