Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }, skip: [:registrations]
  devise_scope :user do
    get 'signup', to: 'users/registrations#new', as: :new_user_registration
    post 'signup', to: 'users/registrations#create', as: :user_registration
  end

  root "home#index"
end
