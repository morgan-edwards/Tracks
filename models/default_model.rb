require_relative "tracks_model"

class DefaultModel < TracksModel
  belongs_to :collection
  finalize!
end
