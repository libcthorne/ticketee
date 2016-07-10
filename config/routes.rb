Rails.application.routes.draw do
  namespace :admin do
    #get 'application/index"
    root "application#index"

    resources :projects, only: [:new, :create, :destroy]
    resources :users do
      member do # member routes (for acting on single instances)
        patch :archive # defines archive_admin_user_path
      end
    end
  end

  devise_for :users

  root "projects#index"

  resources :projects, only: [:index, :show, :edit, :update] do
    resources :tickets
  end
end
