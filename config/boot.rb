# Note: This booter does not use the same pattern as Rails - it's much simpler


require 'rubygems'
require 'Qt4'
require 'activerecord'

#require 'activeresource'
#require 'actionpack'
#require 'activesupport'

require 'config/requires_list'

module QtRails

  QTRAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(QTRAILS_ROOT)
  RAILS_ROOT = "#{QTRAILS_ROOT}/../../.." unless defined?(RAILS_ROOT)

  class Boot

    def self.start
      require "#{QTRAILS_ROOT}/lib/n_v_pair.rb"

      Dir.glob("#{RAILS_ROOT}/app/models/*.rb") {|f| require f}
      Dir.glob("#{QTRAILS_ROOT}/app/qtablemodels/*.rb") {|f| require f}
      Dir.glob("#{QTRAILS_ROOT}/app/qcontrollers/*.rb") {|f| require f}
      Dir.glob("#{QTRAILS_ROOT}/app/qviews/*.rb") {|f| require f}
      Dir.glob("#{QTRAILS_ROOT}/app/qpresenters/*.rb") {|f| require f}

      require "#{QTRAILS_ROOT}/lib/router.rb"
      require "#{QTRAILS_ROOT}/config/environment.rb"

      setup_database
    end

    def self.setup_database
      db_config = YAML::load(IO.read(
        "#{RAILS_ROOT}/config/database.yml"))[QTRAILS_ENV]

      ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        :database => '../../../' + db_config["database"]) 

   end

  end

end

QtRails::Boot.start
