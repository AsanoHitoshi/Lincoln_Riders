Rails.application.routes.draw do

#for users
	devise_for :users, :path => "users",controllers: {
		sessions:      'users/sessions',
		passwords:     'users/passwords',
		registrations: 'users/registrations'
	}
	root 'lincoln_riders/homes#top'

	namespace :lincoln_riders do
		get 'homes/about' => 'homes#about', as: 'about'
		root 'homes#top'

		get 'users/mypage/' => 'users#mypage',as: 'user_mypage'
		get 'users/mypage/posts' => 'users#mypage_posts',as: 'user_mypage_posts'
		get 'users/mypage/posts/favs' => 'users#mypage_fav_posts',as: 'user_mypage_fav_posts'
		get 'users/mypage/mapped_images' => 'users#mypage_mapped_images',as: 'user_mypage_mapped_images'
		get 'users/mypage/mapped_images/favs' => 'users#mypage_fav_mapped_images',as: 'user_mypage_fav_mapped_images'
		get 'users/:id/posts' => 'users#show_posts',as: 'user_show_posts'
		get 'users/:id/posts/favs' => 'users#show_fav_posts',as: 'user_show_fav_posts'
		get 'users/:id/mapped_images' => 'users#show_mapped_images',as: 'user_show_mapped_images'
		get 'users/:id/mapped_images/favs' => 'users#show_fav_mapped_images',as: 'user_show_fav_mapped_images'
		resources :users, only: [:edit,:update,:update,:show,:destroy] do
			resource :follow_relationships, only: [:create, :destroy]
			get :following_users_index, on: :member
			get :followed_users_index, on: :member
		end

		get 'posts/search' => 'posts#search', as: 'posts_search'
		resources :posts, only: [:new,:index,:create,:show,:edit,:destroy,:update] do
			resource :post_favs, only: [:create, :destroy]
			resource :reply_relationships, only: [:create, :new]
		end

		get 'mapped_images' => 'mapped_images#index', as: 'mapped_images'
		get 'mapped_images/search' => 'mapped_images#search', as: 'mapped_images_search'
		get 'mapped_images/get_window_content' => 'mapped_images#get_window_content'
		get 'mapped_images/get_near_markers' => 'mapped_images#get_near_markers'
		resources :mapped_images,only: [:create,:show,:edit,:update,:destroy,:new] do
			resource :mapped_images_favs, only: [:create, :destroy]
		end

	end

#for admins
	devise_for :admins, controllers: {
		sessions:      'admins/sessions',
		passwords:     'admins/passwords',
	}
	namespace :admins do
		root 'home#top'
		resources :users, only: [:index, :show, :destroy]
		resources :posts, only: [:index, :show, :destroy]
		resources :mapped_images, only: [:index, :show, :destroy]
	end
end
