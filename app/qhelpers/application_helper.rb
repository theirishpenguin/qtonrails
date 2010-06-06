# Methods added to this helper can be included in any presenter using 'include ApplicationHelper' 
module ApplicationHelper

    def formatted_errors_for(record)
        return nil if record.errors.empty?

        "Please correct the following errors:\n" +
        record.errors.map{|k,v| "#{k} #{v}"}.join("\n")
    end

end
