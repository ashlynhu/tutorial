module ApplicationHelper

	# Returns full title on a per-page basis
	def full_title(page_title = '')
		base_title = "Tutorial"
		if page_title.empty?
			base_title			# Implicit return
		else
			page_title + " | " + base_title
		end
	end

end
