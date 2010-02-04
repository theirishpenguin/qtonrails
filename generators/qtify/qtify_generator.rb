class QtifyGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|

      puts "Beginning Qt-ification of #{class_name} model"
      puts '*' * 40
      puts `script/generate qform #{class_name}`
      puts `script/generate qpresenters`
      puts `script/generate qtablemodel #{class_name}`
      puts `script/generate qcontroller #{class_name}`
      puts `script/generate qview #{class_name}`
      puts `script/generate qmainwindow`
      puts `script/generate qmainwindow` # NNB: Must do this last step twice!!! Dunno why
      puts '*' * 40
      puts "Completed Qt-ification of #{class_name} model"

    end
  end

end
