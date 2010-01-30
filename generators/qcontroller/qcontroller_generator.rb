class QcontrollerGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|

      qcontrollers_dir = 'vendor/plugins/qtonrails/app/qcontrollers'
      m.directory qcontrollers_dir
      m.template('qcontroller.rb.template', "#{qcontrollers_dir}/#{plural_name}_controller.rb", :assigns => {:class_name => class_name } )
    end
  end

end
