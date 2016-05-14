require 'rails_helper'

RSpec.describe TaskEntriesController, type: :controller do
  render_views
  it "has a valid factory" do
    expect(FactoryGirl.create(:task_entry)).to be_valid
  end

  context 'when not logged in' do
    describe 'GET #new' do
      it 'redirects to new sessions path' do
        get :new, task_id: 1
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe 'GET #edit' do
      it 'redirects to new sessions path' do
        get :edit, id: 1
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe 'GET #show' do
      it 'redirects to new sessions path' do
        get :show, id: 1
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  context 'when logged in' do
    include SessionsHelper
    before :each do
      @task = FactoryGirl.create(:task)
      login(@task.user)
    end
    after :each do
      logout
      @task = nil
    end

    describe 'GET #new' do
      context 'html' do
        it 'renders new task_entry page' do
          get :new, task_id: @task.id
          expect(response).to render_template(:new)
        end
      end
      context 'ajax' do
        it 'renders new entry form' do
          xhr :get, :new, task_id:@task.id
          expect(response).to render_template(partial: "_new_entry_form")
        end
      end
    end
    describe 'GET #edit' do
      before :each do
        @tsk_entry = @task.task_entries.create(FactoryGirl.attributes_for(:task_entry))
      end
      after :each do
        @tsk_entry = nil
      end
      context 'html' do
        it 'serves the edit page' do
          get :edit, id:@tsk_entry
          expect(response).to render_template(:edit)
        end
        it 'populates correct task entry model' do
          get :edit, id:@tsk_entry
          expect(assigns(:task_entry)).to eq(@tsk_entry)
        end
      end
      context 'ajax' do
        it 'serves the edit form' do
          xhr :get, :edit, id:@tsk_entry
          expect(response).to render_template(partial: "_edit_entry_form")
        end
        it 'populates correct task entry model' do
          xhr :get, :edit, id:@tsk_entry
          expect(assigns(:task_entry)).to eq(@tsk_entry)
        end
      end
    end
    describe 'GET #show' do
      before :each do
        @tsk_entry = @task.task_entries.create(FactoryGirl.attributes_for(:task_entry))
      end
      after :each do
        @tsk_entry = nil
      end
      it 'serves the show page' do
        get :show, id:@tsk_entry
        expect(response).to render_template(:show)
      end
      it 'populates correct task entry model' do
        get :show, id:@tsk_entry
        expect(assigns(:task_entry)).to eq(@tsk_entry)
      end      
    end
    describe 'DELETE #destroy' do
      before :each do
        @tsk_entry = @task.task_entries.create(FactoryGirl.attributes_for(:task_entry))
      end
      after :each do
        @tsk_entry = nil
      end
      context 'html' do
        it 'removes the record from the db' do
          expect{
            delete :destroy, id:@tsk_entry
          }.to change(TaskEntry, :count).by(-1)
        end
        it 'redirects to the task show page' do
          delete :destroy, id:@tsk_entry
          expect(response).to redirect_to(task_path(@task))
        end
      end
      context 'ajax' do
        it 'removes the record from the db' do
          expect{
            xhr :delete, :destroy, id:@tsk_entry
          }.to change(TaskEntry, :count).by(-1)
        end
        it 'gives a 200 status' do
          xhr :delete, :destroy, id:@tsk_entry
          expect(response).to have_http_status(200)
        end
      end
    end
    describe 'POST #update' do
      before :each do
        @tsk_entry = @task.task_entries.create(FactoryGirl.attributes_for(:task_entry))
      end
      after :each do
        @tsk_entry = nil
      end
      context 'html' do
        it 'locates the correct task_entry' do
          put :update, id:@tsk_entry, task_entry:FactoryGirl.attributes_for(:form_field_values)
          expect(assigns(:task_entry)).to eq(@tsk_entry)
        end
        it 'updates model attributes' do
          put :update, id:@tsk_entry, task_entry:FactoryGirl.attributes_for(:form_field_values)
          @tsk_entry.reload
          expect(@tsk_entry).to have_attributes(FactoryGirl.attributes_for(:form_field_values))
        end
        it 'redirects to task_entry show page' do
          put :update, id:@tsk_entry, task_entry:FactoryGirl.attributes_for(:form_field_values)
          expect(response).to redirect_to(task_entry_path(@tsk_entry))
        end
      end
      context 'ajax' do
        it 'locates the correct entry' do
          xhr :put, :update, id:@tsk_entry, task_entry:FactoryGirl.attributes_for(:form_field_values)
          expect(assigns(:task_entry)).to eq(@tsk_entry)
        end
        it 'updates model attributes' do
          xhr :put, :update, id:@tsk_entry, task_entry:FactoryGirl.attributes_for(:form_field_values)
          @tsk_entry.reload
          expect(@tsk_entry).to have_attributes(FactoryGirl.attributes_for(:form_field_values))
        end
        it 'returns nested entry partial' do
          xhr :put, :update, id:@tsk_entry, task_entry:FactoryGirl.attributes_for(:form_field_values)
          expect(response).to render_template(partial:"_nested_task")
        end
      end
    end
    describe 'POST #create' do
      context 'with valid model params' do
        context 'html' do
          it 'saves new entry to db' do
            expect{
              post :create, task_id:@task.id, task_entry: FactoryGirl.attributes_for(:form_field_values)
            }.to change(TaskEntry, :count).by(1)
          end
          it 'correctly saves the data' do
            post :create, task_id:@task.id, task_entry:FactoryGirl.attributes_for(:form_field_values)
            expect(TaskEntry.last).to have_attributes(FactoryGirl.attributes_for(:form_field_values))
          end
          it 'redirects to new task_entry show page' do
            post :create, task_id:@task.id, task_entry: FactoryGirl.attributes_for(:form_field_values)
            expect(response).to redirect_to(task_entry_path(TaskEntry.last))
          end
        end
        context 'ajax' do
          it 'saves new entry to db' do
            expect{
              xhr :post, :create, task_id:@task.id, task_entry:FactoryGirl.attributes_for(:form_field_values)
            }.to change(TaskEntry, :count).by(1)
          end
          it 'correctly saves the data' do
            xhr :post, :create, task_id:@task.id, task_entry:FactoryGirl.attributes_for(:form_field_values)
            expect(TaskEntry.last).to have_attributes(FactoryGirl.attributes_for(:form_field_values))
          end
          it 'renders nested_entry partial' do
            xhr :post, :create, task_id:@task.id, task_entry:FactoryGirl.attributes_for(:form_field_values)
            expect(response).to render_template(partial:"_nested_task")
          end
        end
      end
    end
  end
end