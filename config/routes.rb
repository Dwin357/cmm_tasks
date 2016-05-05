Rails.application.routes.draw do
  shallow do
    resources :customers do
      resources :projects, except: [:index] do
        resources :tasks, except: [:index] do
          resources :task_entries, except: [:index]
        end
      end
    end
  end
  resources :users, except: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  root "root#index"
  get "/scratch" => "root#scratch"
end
