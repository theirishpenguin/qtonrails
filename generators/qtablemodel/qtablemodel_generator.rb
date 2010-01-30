class QtablemodelGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|

      qtablemodel_dir = 'vendor/plugins/qtonrails/app/qtablemodels'
      m.directory qtablemodel_dir

      m.template('qtablemodel.rb.template', "#{qtablemodel_dir}/#{file_path}_qtablemodel.rb", :assigns => {:model_keys => model_keys(eval(class_name).new) } )

      m.template('qtablemodel_gen.rb.template', "#{qtablemodel_dir}/#{file_path}_qtablemodel_gen.rb", :assigns => {:model_keys => model_keys(eval(class_name).new), :class_name => class_name } )

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
