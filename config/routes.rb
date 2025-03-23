Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }, skip: [:registrations]
  devise_scope :user do
    get 'signup', to: 'users/registrations#new', as: :new_user_registration
    post 'signup', to: 'users/registrations#create', as: :user_registration
  end

  resources :courses, only: %i[index new create show destroy] do
    get 'search', on: :collection
  end

  # プライバシーポリシー
  get 'privacy_policy', to: 'home#privacy_policy'

  # トップページ
  root "home#index"
end
