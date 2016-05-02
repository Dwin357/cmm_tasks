require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  it "has a valid factory" do
    expect(FactoryGirl.create(:project)).to be_valid
  end


  context 'when not logged in' do
    describe 'GET #new' do
      it 'redirects to new session path' do
        get :new, customer_id: 1
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe 'GET #edit' do
      it 'redirects to new session path' do
        get :edit, id:1
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe 'GET #show' do
      it 'redirects to new session path' do
        get :show, id:1
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  context 'when logged in' do   
    include SessionsHelper
    before :each do 
      login(FactoryGirl.create(:user))
      @project_customer = FactoryGirl.create(:customer)
    end
    after :each do 
      logout 
      @project_customer = nil
    end

    describe 'GET #new' do
      it 'renders new projects page' do
        get :new, customer_id: @project_customer.id
        expect(response).to render_template(:new)
      end
    end

    describe 'GET #edit' do
      before :each do
        @prj = @project_customer.projects.create(FactoryGirl.attributes_for(:project))
      end
      after :each do
        @prj = nil
      end
      it 'serves the edit page' do
        get :edit, id:@prj
        expect(response).to render_template(:edit)
      end
      it 'populates correct project model' do
        get :edit, id:@prj
        expect(assigns(:project)).to eq(@prj)
      end
    end

    describe 'GET #show' do
      before :each do
        @prj = @project_customer.projects.create(FactoryGirl.attributes_for(:project))
      end
      after :each do
        @prj = nil
      end
      it 'renders the show page' do
        get :show, id:@prj
        expect(response).to render_template(:show)
      end
      it 'populates correct model' do
        get :show, id:@prj
        expect(assigns(:project)).to eq(@prj)
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @prj = @project_customer.projects.create(FactoryGirl.attributes_for(:project))
      end
      after :each do
        @prj = nil
      end
      it "removes the record from the db" do
        expect{
          delete :destroy, id:@prj
        }.to change(Project, :count).by(-1)
      end
      it "redirects to customer show page" do
        delete :destroy, id:@prj
        expect(response).to redirect_to(customer_path(@project_customer))
      end
    end

    describe 'POST #update' do
      context 'with valid model params' do
        before :each do
          @prj = @project_customer.projects.create(FactoryGirl.attributes_for(:project))
        end
        after :each do
          @prj = nil
        end
        it 'locates the correct project' do
          put :update, id:@prj, project: FactoryGirl.attributes_for(:alt_project)
          expect(assigns(:project)).to eq(@prj)
        end
        it 'updates model attributes' do
          comparison = FactoryGirl.build(:alt_project)
          comparison.id = @prj.id
          put :update, id:@prj, project: FactoryGirl.attributes_for(:alt_project)
          @prj.reload
          expect(@prj).to eq(comparison)
        end
        it 'redirects to project show page' do
          put :update, id:@prj, project: FactoryGirl.attributes_for(:alt_project)
          expect(response).to redirect_to(project_path(@prj))
        end
      end
      # context "with invalid params" ##no validations yet
    end

    describe 'POST #create' do
      context 'with valid model params' do
        it 'saves new project to db' do
          expect{
            post :create, customer_id: @project_customer.id, project: FactoryGirl.attributes_for(:project)
          }.to change(Project, :count).by(1)
        end
        it 'redirects to new projects show page' do
          post :create, customer_id: @project_customer.id, project: FactoryGirl.attributes_for(:project)
          expect(response).to redirect_to(project_path(Project.last))
        end
      end
      # # context "no model validations yet"
    end
  end

end