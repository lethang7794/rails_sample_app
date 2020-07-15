module UsersHelper

	# Return the Gravatar for the given user (expanded to Rohohash avatar).
	# More info about Rohohash can be found at https://robohash.org/
	def gravatar_for(user, size: 80, site: 'robohash', set: 'set5', bgset: 'bg1', klass: "")
		return nil unless user.email

		image_tag avatar_url(user, size: size, site: site, set: set, bgset: bgset), alt: user.name, class: "gravatar #{klass}"
	end

	# Return url for user's avatar using Gravatar/Robohash services.
	def avatar_url(user, size: 80, site: 'robohash', set: 'set5', bgset: 'bg1')
		gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://www.gravatar.com/avatar/#{gravatar_id}?d=mp&s=#{size}"
		gratavar_robohash_url  = "https://robohash.org/#{gravatar_id}?gravatar=hashed&size=#{size}x#{size}&set=#{set}&bgset=#{bgset}"
		# robohash_url = "https://robohash.org/#{user.email.downcase}?size=#{size}x#{size}&set=#{set}&bgset=#{bgset}"
		robohash_url = "https://robohash.org/set_#{set}/bgset_#{bgset}/#{user.email.downcase}?size=#{size}x#{size}"
		if site == 'gravatar_robohash'
			gratavar_robohash_url
		elsif site == 'gravatar'
			gravatar_url
		elsif site == 'robohash'
			robohash_url
		end
	end

	# Returns RGBA color values of dominant color of users's avatar.
	def avatar_dominant_color(user, alpha = 0.9)
		url = avatar_url(user, size: 1)
    image = MiniMagick::Image.open(url)
    red, blue, green = image.get_pixels[0][0]
    "rgba(#{red}, #{blue}, #{green}, #{alpha})"
  end
end
