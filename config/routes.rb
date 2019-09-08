Rails.application.routes.draw do
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

#for users
	devise_for :users, path: 'lincoln_riders/users', controllers: {
		sessions:      'users/sessions',
		passwords:     'users/passwords',
		registrations: 'users/registrations'
	}
	namespace :lincoln_riders do
		get 'users/mypage' => 'users#mypage',as: 'user_mypage'
		get 'homes/about' => 'homes#about', as: 'about'
		root 'homes#top'
		get 'mapped_images' => 'mapped_images#index', as: 'mapped_images'
		get 'mapped_images/get_window_content' => 'mapped_images#get_window_content'
		resources :users,only: [:show,:edit,:update] do
  			resources :posts, only: [:create,:show,:edit,:destroy,:update]
			resources :mapped_images,only: [:create,:show,:edit,:update,:destroy,:new]
  		end
	end

#for admins
	devise_for :admins, controllers: {
		sessions:      'admins/sessions',
		passwords:     'admins/passwords',
		registrations: 'admins/registrations'
	}
	namespace :admins do

	end
end
