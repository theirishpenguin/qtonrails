class QmainwindowGenerator < Rails::Generator::Base

  def manifest
    record do |m|
#require 'ruby-debug' ; debugger

      # Parse any supplied parameters
      # eg. ["nav_items:Home,ToyMasters,Worlds"] => ["nav_items:Home,ToyMasters,Worlds"]
      #
      # Available parameters are
      # - nav_items: Words representing each different navigation item 
      #   that will appear in the navigation menu. Navigation items cannot contain spaces,
      #   instead use CapitalCased nouns which will be split two words. Each navigation item
      #   should be separated by a comma. In a typical Rails app, each 
      #   controller would equate to one navigation item. But it's arbitrary, you can include
      #   a nav item such as Home as your first nav item if you wish to have a home page

      # TODO: Consider allowing a subnav to be generated off 1 level of nested resources
      # nav_items:Home[Mine;Yours],World[Earth;Mars]

      my_args = {}
      args.each {|arg| pair = arg.split(':') and my_args[pair[0]] = pair[1]}

      if my_args['nav_items']
        my_args['nav_items'] = my_args['nav_items'].split(',')
      else
        my_args['nav_items'] = []
      end

      qdesigns_dir = 'vendor/plugins/qtonrails/app/qdesigns'
      m.directory qdesigns_dir
      m.template('ui/qmainwindow_template.ui', "#{qdesigns_dir}/qmainwindow.ui", :assigns => {:nav_items => my_args['nav_items']})

      ui_f = qdesigns_dir + '/qmainwindow.ui'
      ui_proxy_filepath = ui_f.gsub('qdesigns', 'ui_proxies') + '.rb'

      command = %^rbuic4 "#{RAILS_ROOT}/#{ui_f}" -x -o "#{ui_proxy_filepath}"^

      puts command

      system command

      # This is a little more rigid and hardcoded than
      # non-main window presenters
      qpresenters_dir = 'vendor/plugins/qtonrails/app/qpresenters'
      m.directory qpresenters_dir
      m.template('main_window_presenter.rb', "#{qpresenters_dir}/main_window_presenter.rb")

    end
  end

end
