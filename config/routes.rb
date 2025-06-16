Rails.application.routes.draw do
  # 認証
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }, skip: [:registrations]
  devise_scope :user do
    get 'signup', to: 'users/registrations#new', as: :new_user_registration
    post 'signup', to: 'users/registrations#create', as: :user_registration
  end

  # コース
  resources :courses, only: %i[index new create show destroy] do
    get 'search', on: :collection

    # いいね機能
    resources :likes, only: %i[create destroy], shallow: true

    # コメント機能
    resources :comments, only: %i[new create destroy], shallow: true
  end

  # プロフィール
  resource :profile, only: %i[show edit update]

  # プライバシーポリシー
  get 'privacy_policy', to: 'home#privacy_policy'

  # 利用規約
  get 'terms_of_use', to: 'home#terms_of_use'

  # トップページ
  root "home#index"
end
