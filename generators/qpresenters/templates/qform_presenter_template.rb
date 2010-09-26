# We pull in the file containing the class which consists of generated code
require 'app/ui_proxies/<%= proxy_file %>' #eg. product_qform.ui.rb


# We inherit from Qt:MainWindow as it gives us access to User Interface
# functionality such as connecting slots and signals
class <%= class_name %>Window < Qt::MainWindow
    include ApplicationHelper

    slots 'save_clicked()'
    slots 'cancel_clicked()'

    signals 'form_data_changed()'

    # We are then free to put our own code into this class without fear
    # of it being overwritten. Here we add a initialize function which
    # can be used to customise how the form looks on startup. The method
    # initialize() is a constructor in Ruby
 
    def initialize(parent, record)
 
       # Widgets in Qt can optionally be children of other widgets.
       # That's why we accept parent as a parameter
 
       # This super call causes the constructor of the base class (Qt::Widget)
       # to be called, shepherding on the parent argument
 
       super(parent)
 
       # Hold a reference to the domain object which contains the data - record
       @record = record

       # The class we are in holds presentation logic and exists
       # to 'manage' the Window widget we created in Qt Designer earlier.
       # An instance of this Window widget is created and stored in @ui variable
 
       @ui = Ui::<%= class_name %>Window.new
 
       # Calling setup_ui causes the Window widget to be initialised with the
       # defaults you may have specified in Qt Designer. Peer into the 
       # related xxx_qform_ui.rb if you want to the full gory details
 
       @ui.setup_ui(self)
 
       connect(@ui.save_button, SIGNAL('clicked()'), self, SLOT('save_clicked()'))
       connect(@ui.cancel_button, SIGNAL('clicked()'), self, SLOT('close()'))

       connect(self, SIGNAL('form_data_changed()'), parent, SLOT('refresh_now()'))

       load_data
    end

    def load_data
       <%- model_columns.each do |col| -%>
       <%- col_name = col['name'] -%>
       <%- col_type = col['type'] -%>
       <%- if col_type == :datetime -%>
       @ui.<%= col_name %>_date_time_edit.date_time =
            QtrSupport::ruby_to_qt_date_time(@record.<%= col_name %>) if @record.respond_to? :<%= col_name %> and @record.<%= col_name %>.present?
       <%- elsif col_type == :time -%>
       @ui.<%= col_name %>_time_edit.time =
            QtrSupport::ruby_to_qt_time(@record.<%= col_name %>) if @record.respond_to? :<%= col_name %> and @record.<%= col_name %>.present?
       <%- elsif col_type == :date -%>
       @ui.<%= col_name %>_date_edit.date =
            QtrSupport::ruby_to_qt_date(@record.<%= col_name %>) if @record.respond_to? :<%= col_name %> and @record.<%= col_name %>.present?
       <%- else -%>
       @ui.<%= col_name %>_line_edit.text = @record.<%= col_name %> if @record.respond_to? :<%= col_name %> and @record.<%= col_name %>.present?
       <%- end -%>
       <%- end -%>

    end


    def save_clicked()
       <%- model_columns.each do |col| -%>
       <%- col_name = col['name'] -%>
       <%- col_type = col['type'] -%>
       <%- if col_type == :datetime -%>
       @record.<%= col_name %> = QtrSupport::qt_to_ruby_date_time(@ui.<%= col_name %>_date_time_edit.date_time)
       <%- elsif col_type == :time -%>
       @record.<%= col_name %> = QtrSupport::qt_to_ruby_time(@ui.<%= col_name %>_time_edit.time)
       <%- elsif col_type == :date -%>
       @record.<%= col_name %> = QtrSupport::qt_to_ruby_date(@ui.<%= col_name %>_date_edit.date)
       <%- else -%>
       @record.<%= col_name %> = @ui.<%= col_name %>_line_edit.text
       <%- end -%>
       <%- end -%>
       @record.save

       error_message = formatted_errors_for(@record)

       if error_message
            msgBox = Qt::MessageBox.new(self)
            msgBox.set_window_title('Error');
            msgBox.set_text(error_message);
            msgBox.exec();
       else
            form_data_changed()
            close()
       end
    end

end
