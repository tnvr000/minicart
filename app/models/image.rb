class Image < ActiveRecord::Base
	belongs_to :imageable, polymorphic: true

	has_attached_file :image,
		path: ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
		url: "/system/:attachment/:id/:basename_:style.:extension",
		# default_url: "system/missing.png",
		styles: {
			thumb: ["64x64#", :png],
			small: ["128x128#", :png],
			medium: ["256x256#", :png],
			large: ["512>", :png],
			x_large: ["1024>", :png]
		}



		validates_attachment :image,
			content_type: {content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]}

		def make_thumb
			old_thumb = self.imageable.thumb;
			old_thumb.update_attributes(default: false) unless old_thumb.nil?
			self.update_attributes(default: true)
		end
end
