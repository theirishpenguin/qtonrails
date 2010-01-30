class Router
  require 'config/routes'

  # TODO: Move @@params out of Routing System
  @@params = {}


  def self.params
    @@params
  end

  def self.reset_params
    @@params = {}
  end


  def self.choose(route = {})
    route = DEFAULT_ROUTE.clone if route.blank?
    name = route[:controller].to_s.capitalize

    # FIXME: TEMP HACK UNTIL WE HAVE BOTH INDEX AND EDIT SCREENS
    # WORKING TOGETHER THROUGH THE ROUTING SYSTEM
    #@@params[:id] = 2

    view = eval("#{name}View")
    controller = eval("#{name}Controller")
    data = controller.new.send(route[:action])
    view.new.send(route[:action], data)
    reset_params
  end

end
