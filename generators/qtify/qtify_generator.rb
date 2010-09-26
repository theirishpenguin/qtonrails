require 'fileutils'

class QtifyGenerator < Rails::Generator::Base

  def manifest

    record do |m|

      qactive_resource_names = []
      qactive_resource_args = []
      # Extract any qactiveresource arguments, eg. taking Search from the following...
      # ./script/generate qtify Fixture Search:http://example.com[xml,/search.xml?q=ebi,id:integer,name:string,description:text])
      args.each do |arg|
        if arg.include? '[' # this is how we idenify an activeresource arg
          qactive_resource_name = arg.split(':').first
          qactive_resource_names << qactive_resource_name 
          qactive_resource_args << arg
        end
      end
  
      # Remove qactive_resouce args
      args.delete_if {|arg| arg.include? '[' }

      # Note: This can currently only generate one controller without hanging as an
      # existing config/routes.rb under qtonrails will cause trouble for subsequent generations

      named_args = [] # We will extract args that include a colon as named arguments
      active_record_sections = []
      args.each do |arg|
        named_args = args.select {|arg| arg.include? ':' }
        active_record_sections = args - named_args
      end

      active_record_sections.each do |class_name|
        puts "Beginning Qt-ification of #{class_name} model"
        puts '*' * 40
        puts `script/generate qform #{class_name}`
        puts `script/generate qpresenters`
        FileUtils.rm_rf 'vendor/plugins/qtonrails/config/routes.rb'  # HACK! NEEDED AS ANY PROMPT HANGS SCRIPT
        puts `script/generate qcontroller #{class_name}`
        puts `script/generate qview #{class_name}`
        puts '*' * 40
        puts "Completed Qt-ification of #{class_name} model"
        puts ""
      end

      qactive_resource_args.each_with_index do |cmd, i|
        qactive_resource_name = qactive_resource_names[i] 
        puts "Beginning Qt-ification of remote resources"
        puts '*' * 40
        puts 'Warning: This will overwrite any ActiveResource models requested to be generated under app/models. Ok? (Press Return to continue or Ctrl-C to exit)'
        gets
        puts '*' * 40
        puts `script/generate qactiveresource #{cmd}`
        puts `script/generate qform #{qactive_resource_name}`
        puts `script/generate qpresenters`
        FileUtils.rm_rf 'vendor/plugins/qtonrails/config/routes.rb'  # HACK! NEEDED AS ANY PROMPT HANGS SCRIPT
        puts `script/generate qcontroller #{qactive_resource_name} --remote-resource`
        puts `script/generate qview #{qactive_resource_name}`
        puts '*' * 40
        puts "Completed Qt-ification of remote resources"
        puts ""
      end

      sections = active_record_sections + qactive_resource_names

      puts "Generating main window"
      puts '*' * 40
      FileUtils.rm_rf 'vendor/plugins/qtonrails/app/qdesigns/qmainwindow.ui' # HACK! NEEDED AS ANY PROMPT HANGS SCRIPT
      # Note: We pluralize here as the navigation items should be plural (like a controller name, not a model name)
      puts `script/generate qmainwindow nav_items:#{sections.map(&:pluralize).join(',')} #{named_args.join(' ')}`
      puts `script/generate qmainwindow nav_items:#{sections.map(&:pluralize).join(',')} #{named_args.join(' ')}` # NNB: Must do this last step twice!!! Dunno why
      puts '*' * 40
      puts "Completed main window"

    end
  end

end
