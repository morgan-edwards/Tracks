require_relative "tracks_model"

class Collection < TracksModel
  belongs_to :user
  has_may :things
  finalize!
end
