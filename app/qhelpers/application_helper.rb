# Methods added to this helper can be included in any presenter using 'include ApplicationHelper' 
module ApplicationHelper

    def formatted_errors_for(record)
        return nil if record.errors.empty?

        "Please correct the following errors:\n" +
        record.errors.map{|k,v| "#{k} #{v}"}.join("\n")
    end

    def ruby_to_qt_date_time(datetime)
        Qt::DateTime.new(
            ruby_to_qt_date(datetime),
            ruby_to_qt_time(datetime)
        )
    end

    def ruby_to_qt_date(date)
        Qt::Date.new(date.year, date.month, date.day)
    end

    def ruby_to_qt_time(time)
        Qt::Time.new(time.hour, time.min, time.sec)
    end


    def qt_to_ruby_date_time(datetime)

        date = datetime.date
        time = datetime.time

        DateTime.civil(
            date.year, date.month, date.day,
            time.hour, time.minute, time.second
        )
    end

    def qt_to_ruby_date(date)
        Date.civil(date.year, date.month, date.day)
    end

    def qt_to_ruby_time(time)
        raise NotImplementedError
    end
end
