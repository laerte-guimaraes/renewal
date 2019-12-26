Rails.application.routes.draw do
  devise_for :users

  get 'template', to: 'template#test'

	devise_scope :user do
	  authenticated :user do
	    root 'home#dashboard', as: :authenticated_root
	  end

	  unauthenticated do
	    root 'devise/sessions#new', as: :unauthenticated_root
	  end
	end
end
