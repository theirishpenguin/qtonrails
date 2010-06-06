# We pull in the file containing the class which consists of generated code
require 'app/ui_proxies/qmainwindow.ui.rb'


# We inherit from Qt:MainWindow as it gives us access to User Interface
# functionality such as connecting slots and signals
class MainWindow < Qt::MainWindow

    ID_COLUMN = 0

    @active_controller = nil

    # Expose slots
    slots 'view_clicked()'
    slots 'new_clicked()'
    slots 'edit_clicked()'
    slots 'delete_clicked()'
    <% nav_items.each do |nav_item| %>
    slots '<%= nav_item.underscore %>_nav_clicked()'
    <% end %>
    slots 'refresh_now()'

    # Example of how to expose a signal
    # signals 'selectionChanged(QItemSelection &selected)'

    # We are then free to put our own code into this class without fear
    # of it being overwritten. Here we add a initialize function which
    # can be used to customise how the form looks on startup. The method
    # initialize() is a constructor in Ruby
 
    def initialize(parent, tablemodel, active_controller)

       @active_controller = active_controller

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
       @tableview = @ui.tableView
       @tableview.setColumnHidden(ID_COLUMN, true)

       # TODO: Look into selecting a whole row at a time rather than by cell
       # Something like @tableview.selectionModel = Qt::ItemSelectionModel::Rows
 
       # NNB: No need to store the tablemodel underpinning the view like 
       # this as it is always available via @tableview.currentIndex().model
       # 
       # @tablemodel = tablemodel # ie. Don't do this

       connect(@ui.viewButton, SIGNAL('clicked()'), self, SLOT('view_clicked()'))
       connect(@ui.newButton, SIGNAL('clicked()'), self, SLOT('new_clicked()'))
       connect(@ui.editButton, SIGNAL('clicked()'), self, SLOT('edit_clicked()'))
       connect(@ui.deleteButton, SIGNAL('clicked()'), self, SLOT('delete_clicked()'))
      <% nav_items.each do |nav_item| %>
      connect(@ui.<%= nav_item.camelize(:lower) %>NavLinkButton, SIGNAL('clicked()'), self, SLOT('<%= nav_item.underscore %>_nav_clicked()'))
      <% end %>
       
       connect(@ui.actionQuit, SIGNAL('triggered()'), self, SLOT('close()'))

       # Example of wiring a signal to a slot. Note how the C++ notation is used for the params
       #connect(@tablemodel, SIGNAL('selectionChanged(QItemSelection &selected)'), self, SLOT('rememberSelection(QItemSelection &selected)'))
      
    end

    def view_clicked
        Router.params[:id] = record_id()
        Router.choose({:controller => @active_controller, :action => 'view'})
    end

    def new_clicked
        
        Router.choose({:controller => @active_controller, :action => 'new'})
    end

    def edit_clicked
        
        Router.params[:id] = record_id()
        Router.choose({:controller => @active_controller, :action => 'edit'})
    end

    def delete_clicked
        
        Router.params[:id] = record_id()
        Router.choose({:controller => @active_controller, :action => 'delete'})

        refresh_now
    end

    <% nav_items.each do |nav_item| %>
    def <%= nav_item.underscore %>_nav_clicked
        @active_controller = '<%= nav_item %>'
        Router.reindex('<%= nav_item %>', self)
    end

    <% end %>

    # def rememberSelection(selected)
    #   Example of a slot implementation
    # end

     def record_id
        model_index_to_record_id(@tableview.currentIndex)
     end


     def model_index_to_record_id(index)

       # The child() function allows us to retrieve
       # the index for any cell in the view

       # The data() call then gives us the data in this
       # cell. It retuns a QVariant which needs to be
       # converted using toInt()

       index.child(index.row, ID_COLUMN).data.toInt()
     end

     def refresh_now

       # Important: We delegate to the router (& ultimately
       # the controller) so that we involve the controller
       # in the retrieval of data
       Router.reindex(@active_controller.camelcase, self)
     end

     def reset_table(tablemodel)
       @tableview.model = tablemodel
     end
end
