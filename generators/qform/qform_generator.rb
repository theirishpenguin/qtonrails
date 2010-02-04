class QformGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|
      qdesigns_dir = 'vendor/plugins/qtonrails/app/qdesigns'
      m.directory qdesigns_dir
      m.template('ui/qform_1col_template.ui', "#{qdesigns_dir}/#{singular_name}_qform.ui", :assigns => {:model_keys => model_keys(eval(class_name).new), :class_name => class_name } )
    end
  end

  def model_keys(a_model)

    # Ensure that timestamps appear at the end if they exist
    the_model_keys = a_model.attributes.keys.clone

    timestamps = the_model_keys.reject do |k|
        ['created_at', 'updated_at'].include? k
    end

    the_model_keys = the_model_keys - timestamps
    timestamps + the_model_keys
  end

end
