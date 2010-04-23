require 'rubygems'
require 'test/unit'
require 'active_support/core_ext'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database  => ":memory:"
)

ActiveRecord::Schema.define do
    create_table :venues do |t|
        t.string :name
        t.string :address
    end
end

# Require Geocoder after ActiveRecord simulator.
require 'geocoder'

##
# Mock HTTP request to Google.
#
module Geocoder
  def self._fetch_xml(query)
    filename = File.join("test", "fixtures", "madison_square_garden.xml")
    File.read(filename)
  end
end

##
# Geocoded model.
#
class Venue < ActiveRecord::Base
  geocoded_by :address
  
  def initialize(name, address)
    super()
    write_attribute :name, name
    write_attribute :address, address
  end
  
end

class Test::Unit::TestCase
  def venue_params(abbrev)
    {
      :msg => ["Madison Square Garden", "4 Penn Plaza, New York, NY"]
    }[abbrev]
  end
end
