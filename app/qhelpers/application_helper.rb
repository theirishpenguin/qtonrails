# Methods added to this helper can be included in any presenter using 'include ApplicationHelper' 
module ApplicationHelper

    def display_error(error_message)
        msgBox = Qt::MessageBox.new(self)
        msgBox.set_window_title('Error');
        msgBox.set_text(error_message);
        msgBox.exec();
    end


    def formatted_errors_for(record)
        return nil if record.errors.empty?

        "Please correct the following errors:\n" +
        record.errors.map{|k,v| "#{k} #{v}"}.join("\n")
    end

end
