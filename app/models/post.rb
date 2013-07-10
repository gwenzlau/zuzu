class Post < ActiveRecord::Base
	COORDINATE_DELTA = 0.05
 # attr_accessible :content, :lat, :lng

  validates :content, presence: true, length: { maximum: 140 }

   validates :lat, :lng,
            :presence => true,
            :numericality => true
            # :signature, presence: true

  scope :nearby, lambda { |lat, lng|
    where("lat BETWEEN ? AND ?", lat - COORDINATE_DELTA, lat + COORDINATE_DELTA).
    where("lng BETWEEN ? AND ?", lng - COORDINATE_DELTA, lng + COORDINATE_DELTA).
    limit(64)
  }

  def as_json(options = nil)
    {
      :content => self.content,

      :lat => self.lat,
      :lng => self.lng,

      :post_urls => {
        :original => self.post.url
      },

      :created_at => self.created_at.iso8601
    }
  end
end
