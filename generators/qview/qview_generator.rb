class QviewGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|

      qviews_dir = 'vendor/plugins/qtonrails/app/qviews'
      m.directory qviews_dir
      m.template('qview.rb.template', "#{qviews_dir}/#{plural_name}_view.rb", :assigns => {:class_name => class_name } )
    end
  end

end
