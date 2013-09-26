module ApplicationHelper
	def full_title(page_title)
	  base_title = "Kanji Me!"
	  if page_title.empty?
	    base_title
	  else
	    "#{base_title} | #{page_title}"
	  end
	end

	def sidebar_links
		m = {
			:pages => {
				:name => "Home",
				:url => root_path,
				:icon => "icon-home"
			},
			:users => {
				:name => "Users",
				:url => "javascript:void(0);",
				:icon => "icon-group",
				:childs => {
					:user_list => {
						:name => "User List",
						:url => users_path
					},
					:user_new => {
						:name => "New user",
						:url => new_user_path
					},
					:user_show => {
						:name => "User profile",
						:url => user_path(current_user)
					}
				}
			}
		}

		return m
	end
end
