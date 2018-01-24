require_relative "tracks_model"

class User < TrackModel
  has_many :collections
  finalize!
end
