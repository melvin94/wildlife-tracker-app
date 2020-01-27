class Sighting < ApplicationRecord
  belongs_to :animal
  belongs_to :region

  scope :filter_by_date, -> (start_date, end_date) { where(date: start_date..end_date) }
  scope :filter_by_region, -> (region_id) { where(region_id: region_id) }

end
