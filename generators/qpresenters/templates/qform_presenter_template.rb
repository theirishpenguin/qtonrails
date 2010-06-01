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
       <% model_keys.each do |attr_name| %>
       <% if ['created_at', 'updated_at'].include? attr_name %>
       @ui.<%= attr_name %>_line_edit.text = @record.<%= attr_name %>.to_s
       @ui.<%= attr_name %>_line_edit.read_only = true
       <% else %>
       @ui.<%= attr_name %>_line_edit.text = @record.<%= attr_name %>
       <% end %>
       <% end %>

    end


    def save_clicked()
       <% model_keys.reject{|k| ['created_at', 'updated_at'].include? k }.each do |attr_name| %>
       @record.<%= attr_name %> = @ui.<%= attr_name %>_line_edit.text
       <% end %>
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
