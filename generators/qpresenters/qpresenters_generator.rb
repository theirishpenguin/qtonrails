class QpresentersGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      qdesigns_dir = "#{RAILS_ROOT}/vendor/plugins/qtonrails/app/qdesigns"
      ui_files = Dir["#{qdesigns_dir}/*qform.ui"]
      ui_proxies_dir = "#{RAILS_ROOT}/vendor/plugins/qtonrails/app/ui_proxies"
      qpresenters_dir = "#{RAILS_ROOT}/vendor/plugins/qtonrails/app/qpresenters"
#      m.directory ui_proxies_dir
#      m.directory qpresenters_dir
#      # FIXME: Why doesnt 'm.directory ui_proxies_dir' work if space in dir, instead we have to do the following 2 lines
      require 'fileutils'
      FileUtils.mkdir_p ui_proxies_dir
      FileUtils.mkdir_p qpresenters_dir

      ui_files.each do |ui_f|
        #TODO: Tighten up qforms substitution more
        ui_proxy_filepath = ui_f.gsub('qdesigns', 'ui_proxies') + '.rb'
        command = %^rbuic4 "#{ui_f}" -x -o "#{ui_proxy_filepath}"^

        system command

        ui_proxy_filename = File.basename(ui_proxy_filepath) 
        
        lowered_class_name = File.basename(ui_proxy_filename, '_qform.ui.rb')
        class_name = lowered_class_name.camelize 


        m.template('qform_presenter_template.rb', "vendor/plugins/qtonrails/app/qpresenters/#{lowered_class_name}_qform_presenter.rb", :assigns => {:proxy_file => ui_proxy_filename, :model_columns => model_columns(eval class_name), :class_name => class_name } )

        m.template('qform_read_only_presenter_template.rb', "vendor/plugins/qtonrails/app/qpresenters/#{lowered_class_name}_qform_read_only_presenter.rb", :assigns => {:proxy_file => ui_proxy_filename, :model_columns => model_columns(eval class_name), :class_name => class_name } )
      end

    end

   end


  def model_columns(a_class)
    a_class.columns.reject{|col| ['id', 'created_at', 'updated_at'].include? col.name }
  end

end
