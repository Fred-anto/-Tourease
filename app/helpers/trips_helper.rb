module TripsHelper
  def trip_cover_url(trip)
    candidates = [
      (trip.respond_to?(:destination) ? trip.destination : nil),
      (trip.respond_to?(:city)        ? trip.city        : nil),
      (trip.respond_to?(:name)        ? trip.name        : nil),
      (trip.respond_to?(:title)       ? trip.title       : nil)
    ].compact.map(&:to_s).map(&:strip).reject(&:blank?)

    query   = candidates.first
    web_url = query.present? ? ::RoyaltyFreeImageFinder.for_destination(query) : nil
    web_url.presence || asset_path("trip placeholder.jpg")
  end
end
