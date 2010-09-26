# Module for QtOnRails-related utility extensions
module QtrSupport

    def self.ruby_to_qt_date_time(datetime)
        Qt::DateTime.new(
            ruby_to_qt_date(datetime),
            ruby_to_qt_time(datetime)
        )
    end

    def self.ruby_to_qt_date(date)
        Qt::Date.new(date.year, date.month, date.day)
    end

    def self.ruby_to_qt_time(time)
        Qt::Time.new(time.hour, time.min, time.sec)
    end

    def self.qt_to_ruby_date_time(datetime)

        date = datetime.date
        time = datetime.time

        DateTime.civil(
            date.year, date.month, date.day,
            time.hour, time.minute, time.second
        )
    end

    def self.qt_to_ruby_date(date)
        Date.civil(date.year, date.month, date.day)
    end

    def self.qt_to_ruby_time(time)
        # Note: Rails uses the first day of Jan 2000 as a dummy date component
        # of the Time class as Ruby's Time class actually contains date info
        Time.local(2000, 1, 1, time.hour, time.minute, time.second, 0)
    end

     def self.resource_without_leading_site(full_resource_url, site_url)
        # TODO: Make me less static and put me somewhere nice
        full_resource_url.gsub(site_url, '')
    end 

end
