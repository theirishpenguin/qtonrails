# We pull in the file containing the class which consists of generated code
require 'app/ui_proxies/qmainwindow.ui.rb'


# We inherit from Qt:MainWindow as it gives us access to User Interface
# functionality such as connecting slots and signals
class MainWindow < Qt::MainWindow
 
#    slots 'view_clicked()'
#    slots 'new_clicked()'
    slots 'edit_clicked()'
#    slots 'delete_clicked()'

    # We are then free to put our own code into this class without fear
    # of it being overwritten. Here we add a initialize function which
    # can be used to customise how the form looks on startup. The method
    # initialize() is a constructor in Ruby
 
    def initialize(parent, tablemodel)
 
       # Widgets in Qt can optionally be children of other widgets.
       # That's why we accept parent as a parameter
 
       # This super call causes the constructor of the base class (Qt::Widget)
       # to be called, shepherding on the parent argument
 
       super(parent)
 
       # The class we are in holds presentation logic and exists
       # to 'manage' the mainWindow widget we created in Qt Designer earlier.
       # An instance of this mainWindow widget is created and stored in @ui variable
 
       @ui = Ui::MainWindow.new
 
       # Calling setup_ui causes the mainWindow widget to be initialised with the
       # defaults you may have specified in Qt Designer. Peer into the main_ui.rb 
       # if you want to the full gory details
 
       @ui.setup_ui(self)
       @ui.tableView.model = tablemodel
 
       #connect(@ui.viewButton, SIGNAL('clicked()'), self, SLOT('view_clicked()'))
       #connect(@ui.viewButton, SIGNAL('clicked()'), self, SLOT('view_clicked()'))
       connect(@ui.editButton, SIGNAL('clicked()'), self, SLOT('edit_clicked()'))
       #connect(@ui.viewButton, SIGNAL('clicked()'), self, SLOT('view_clicked()'))
       connect(@ui.actionQuit, SIGNAL('triggered()'), self, SLOT('close()'))

    end

    def view_clicked
      # Display View page (perhaps printer friendly)
    end

    def edit_clicked
        Router.params[:id] = 2
        Router.choose({:controller => 'products', :action => 'edit'})
    end

end
