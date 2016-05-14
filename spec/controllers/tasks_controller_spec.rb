require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  render_views

  it "has a valid factory" do
    expect(FactoryGirl.create(:task)).to be_valid
  end

  context 'when not logged in' do
    describe 'GET #new' do
      it 'redirects to new session path' do
        get :new, project_id: 1
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe 'GET #edit' do
      it 'redirects to new session path' do
        get :edit, id: 1
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe 'GET #show' do
      it 'redirects to new session path' do
        get :show, id: 1
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  context 'when logged in' do
    include SessionsHelper
    before :each do
      login(FactoryGirl.create(:user))
      @task_project = FactoryGirl.create(:project)
    end
    after :each do
      logout
      @task_project = nil
    end

    describe "GET #new" do
      context 'html' do
        it 'renders new tasks page' do
          get :new, project_id: @task_project.id
          expect(response).to render_template(:new)
        end
      end
      context 'ajax' do
        it 'renders the new tasks form' do
          xhr :get, :new, project_id: @task_project.id
          expect(response).to render_template(partial:"_new_task_form")
        end
      end
    end
    describe 'GET #edit' do
      before :each do
        @tsk = @task_project.tasks.create(FactoryGirl.attributes_for(:task))
      end
      after :each do
        @tsk = nil
      end
      context 'html' do
        it 'serves the edit page' do
          get :edit, id:@tsk
          expect(response).to render_template(:edit)
        end
        it 'populates correct task model' do
          get :edit, id:@tsk
          expect(assigns(:task)).to eq(@tsk)
        end
      end
      context 'ajax' do
        it 'populates correct task model' do
          xhr :get, :edit, id:@tsk
          expect(assigns(:task)).to eq(@tsk)
        end
        it 'serves the edit form' do
          xhr :get, :edit, id:@tsk
          expect(response).to render_template(partial: "_edit_task_form")
        end
      end
    end
    describe 'GET #show' do
      before :each do
        @tsk = @task_project.tasks.create(FactoryGirl.attributes_for(:task))
      end
      after :each do
        @tsk = nil
      end
      it 'serves the show page' do
        get :show, id:@tsk.id
        expect(response).to render_template(:show)
      end
      it 'populates correct task model' do
        get :show, id:@tsk.id
        expect(assigns(:task)).to eq(@tsk)
      end
    end
    describe 'DELETE #destroy' do
      before :each do
        @tsk = @task_project.tasks.create(FactoryGirl.attributes_for(:task))
      end
      after :each do
        @tsk = nil
      end
      context 'html' do
        it 'removes the record from the db' do
          expect{
            delete :destroy, id:@tsk
          }.to change(Task, :count).by(-1)
        end
        it 'redirects to project show page' do
          delete :destroy, id:@tsk
          expect(response).to redirect_to(project_path(@task_project))
        end
      end
      context 'ajax' do
        it 'removes the record from the db' do
          expect{
            xhr :delete, :destroy, id:@tsk
          }.to change(Task, :count).by(-1)
        end
        it 'gives a 200 status' do
          xhr :delete, :destroy, id:@tsk
          expect(response).to have_http_status(200)
        end
      end
    end
    describe 'POST #update' do
      context 'with valid model params' do
        before :each do
          @tsk = @task_project.tasks.create(FactoryGirl.attributes_for(:task))
        end
        after :each do
          @tsk = nil
        end
        context 'html' do
          it 'locates the correct task' do
            put :update, id:@tsk, task: FactoryGirl.attributes_for(:alt_task)
            expect(assigns(:task)).to eq(@tsk)
          end
          it 'updates model attributes' do
            put :update, id:@tsk, task:FactoryGirl.attributes_for(:alt_task)
            @tsk.reload
            expect(@tsk).to have_attributes(FactoryGirl.attributes_for(:alt_task))
          end
          it 'redirects to task show page' do
            put :update, id:@tsk, task:FactoryGirl.attributes_for(:alt_task)
            expect(response).to redirect_to(task_path(@tsk))
          end
        end
        context 'ajax' do
          it 'locates correct task' do
            xhr :put, :update, id:@tsk, task:FactoryGirl.attributes_for(:alt_task)
            expect(assigns(:task)).to eq(@tsk)
          end
          it 'updates model attributes' do
            xhr :put, :update, id:@tsk, task:FactoryGirl.attributes_for(:alt_task)
            @tsk.reload
            expect(@tsk).to have_attributes(FactoryGirl.attributes_for(:alt_task))
          end
          # it 'redirects to task show page' do
          #   xhr :put, :update, id:@tsk, task:FactoryGirl.attributes_for(:alt_task)
          #   expect(response).to render
          # end
        end
      end
      # # no invalid params yet
    end
    describe 'POST #create' do
      context 'with valid model params' do
        it 'saves new task to db' do
          expect{
            post :create, project_id: @task_project.id, task:FactoryGirl.attributes_for(:task)
          }.to change(Task, :count).by(1)
        end
        it 'correctly populates data' do
          post :create, project_id:@task_project.id, task:FactoryGirl.attributes_for(:task)
          expect(Task.last).to have_attributes(FactoryGirl.attributes_for(:task))
        end
        it 'redirects to new tasks show page' do
          post :create, project_id: @task_project.id, task:FactoryGirl.attributes_for(:task)
          expect(response).to redirect_to(task_path(Task.last))
        end
      end
      # # context 'with invalid model params'
    end
  end
end