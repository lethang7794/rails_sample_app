module UsersHelper

	# Return the Gravatar for the given user (expanded to Rohohash avatar).
	# More info about Rohohash can be found at https://robohash.org/
	def gravatar_for(user, size: 80, site: 'robohash', set: 'set5', bgset: 'bg1')
		gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://www.gravatar.com/avatar/#{gravatar_id}?d=mp&s=#{size}"
		robohash_url  = "https://robohash.org/#{gravatar_id}?gravatar=hashed&size=#{size}x#{size}&set=#{set}&bgset=#{bgset}"

		if site == 'robohash'
			image_tag robohash_url, alt: user.name, class: "gravatar"
		elsif site == 'gravatar'
			image_tag gravatar_url, alt: user.name, class: "gravatar"
		end
	end
end
