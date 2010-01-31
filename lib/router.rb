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

    view = eval("#{name}View")
    controller = eval("#{name}Controller")
    data = controller.new.send(route[:action])
    view.new.send(route[:action], data)
    reset_params
  end

  def self.reindex(name)

    # Note: Reindex'ing does not involve params

    view = eval("#{name}View")
    controller = eval("#{name}Controller")
    data = controller.new.send('index')
    view.new.send('reindex', data)
  end
end
