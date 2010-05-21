class KdeifyGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|

      puts "Beginning KDE-ification of #{class_name} model"
      puts '*' * 40
      puts `script/generate qform #{class_name}`
      puts `script/generate qpresenters`
      puts `script/generate qtablemodel #{class_name}`
      puts `script/generate qcontroller #{class_name}`
      puts `script/generate qview #{class_name}`
      puts `script/generate kmainwindow`
      puts `script/generate kmainwindow` # NNB: Must do this last step twice!!! Dunno why
      puts '*' * 40
      puts "Completed KDE-ification of #{class_name} model"

    end
  end

end
