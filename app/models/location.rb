class Location < ActiveRecord::Base
  has_many :messages
end
