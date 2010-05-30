require 'fileutils'

class QtifyGenerator < Rails::Generator::Base

  def manifest

    record do |m|

      # Note: This can currently only generate one controller without hanging as an
      # existing config/routes.rb under qtonrails will cause trouble for subsequent generations

      args.each do |class_name|
        puts "Beginning Qt-ification of #{class_name} model"
        puts '*' * 40
        puts `script/generate qform #{class_name}`
        puts `script/generate qpresenters`
        FileUtils.rm_rf 'vendor/plugins/qtonrails/config/routes.rb'  # HACK! NEEDED AS ANY PROMPT HANGS SCRIPT
        puts `script/generate qtablemodel #{class_name}`
        puts `script/generate qcontroller #{class_name}`
        puts `script/generate qview #{class_name}`
        puts '*' * 40
        puts "Completed Qt-ification of #{class_name} model"
        puts ""
      end


      puts "Generating main window"
      puts '*' * 40
      FileUtils.rm_rf 'vendor/plugins/qtonrails/app/qdesigns/qmainwindow.ui' # HACK! NEEDED AS ANY PROMPT HANGS SCRIPT
      # Note: We pluralize here as the navigation items should be plural (like a controller name, not a model name)
      puts `script/generate qmainwindow nav_items:#{args.map(&:pluralize).join(',')}`
      puts `script/generate qmainwindow nav_items:#{args.map(&:pluralize).join(',')}` # NNB: Must do this last step twice!!! Dunno why
      puts '*' * 40
      puts "Completed main window"

    end
  end

end
