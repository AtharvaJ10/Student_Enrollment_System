Rails.application.routes.draw do
  resources :waitlists
  resources :enrollments
  resources :students
  resources :instructors

  Rails.application.routes.draw do
    # ...
    post '/create_user' => 'instructors#create_user'
  end
  Rails.application.routes.draw do
    # ...
    post '/create_student' => 'students#create_student'
    post '/edit_user' => 'instructors#edit_user'
    post '/edit_student' => 'students#edit_student'
    post '/edit_admin' => 'instructors#edit_admin'
  end


  """devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end"""
  #devise_for :users, :controllers => {:registrations => "registrations"}
  devise_for :users, controllers: { sessions: "sessions" }
  resources :courses
  #get 'home/index'
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
