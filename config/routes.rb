Rails.application.routes.draw do
  devise_for :users

	devise_scope :user do
	  authenticated :user do
	    root 'home#dashboard', as: :authenticated_root
	  end

	  unauthenticated do
	    root 'devise/sessions#new', as: :unauthenticated_root
	  end
	end

  namespace :api do
    namespace :v1 do
      resources :contracts
    end
  end
end
