class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]

	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = [] 	# Add empty instance to create action when micropost fails
			render 'static_pages/home'
		end
	end

	def destroy
	end

	private

		# Permit only micropost content attribute to be modified through web
		def micropost_params
			params.require(:micropost).permit(:content)
		end
end
