class QtifyGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|

      system "../../../script/generate qform #{class_name}"
      system "../../../script/generate qpresenters"
      system "../../../script/generate qtablemodel #{class_name}"
      system "../../../script/generate qcontroller #{class_name}"
      system "../../../script/generate qview #{class_name}"
      system "../../../script/generate qmainwindow"
      system "../../../script/generate qmainwindow" # NNB: Must do this last step twice!!! Dunno why
      puts "Done"

    end
  end

end
