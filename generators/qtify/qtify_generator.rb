require 'fileutils'

class QtifyGenerator < Rails::Generator::Base

  def manifest

    record do |m|

      # Note: This can currently only generate one controller without hanging as an
      # existing config/routes.rb under qtonrails will cause trouble for subsequent generations

      named_args = [] # We will extract args that include a colon as named arguments

      sections = []
      args.each do |arg|
        named_args = args.select {|arg| arg.include? ':' }
        sections = args - named_args
      end

      sections.each do |class_name|
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
