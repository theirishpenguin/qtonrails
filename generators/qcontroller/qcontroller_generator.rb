class QcontrollerGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|

      qcontrollers_dir = 'vendor/plugins/qtonrails/app/qcontrollers'
      m.directory qcontrollers_dir

      if options[:remote_resource]
        generate_active_resource_qcontroller(m, qcontrollers_dir, class_name, plural_name)
      else # Generate ActiveRecord style of qcontroller
        m.template('qcontroller.rb.template', "#{qcontrollers_dir}/#{plural_name}_controller.rb", :assigns => {:class_name => class_name} )
      end

      qconfig_dir = 'vendor/plugins/qtonrails/config'
      m.directory qconfig_dir
      m.template('routes.rb.template', "#{qconfig_dir}/routes.rb", :assigns => {:default_controller => file_name.pluralize } )

    end
  end


  # This adds switches to the qcontroller generator command.
  # If the switch is specified then it's value is true, if the 
  # switch is omitted then it will have no entry in the options has
  def add_options!(opt)
    opt.on('-r', '--remote-resource') { |value| options[:remote_resource] = value }
  end


  def generate_active_resource_qcontroller(m, qcontrollers_dir, class_name, plural_name)
        remote_resources_config = "vendor/plugins/qtonrails/config/remote_resources.rb"
        format = 'xml'
        if File.exists?(remote_resources_config)
          serialized_obj = File.read remote_resources_config
          if serialized_obj.empty? # In case file is blank
            raise "Remote resources file is empty (#{remote_resources_config})"
          end
          remote_resources = eval(serialized_obj)
          format = remote_resources[class_name]['format']
        else
          raise "No remote resources file found (#{remote_resources_config})"
        end

        m.template('activeresource_qcontroller.rb.template', "#{qcontrollers_dir}/#{plural_name}_controller.rb", :assigns => {:class_name => class_name, :format => format } )

  end

end
