class QformGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|
      qdesigns_dir = 'vendor/plugins/qtonrails/app/qdesigns'
      m.directory qdesigns_dir
      m.template('ui/qform_1col_template.ui', "#{qdesigns_dir}/#{singular_name}_qform.ui", :assigns => {:model_columns => model_columns(eval class_name), :class_name => class_name } )
    end
  end

  def model_columns(a_class)
    a_class.columns.reject{|col| ['id', 'created_at', 'updated_at'].include? col.name }
  end

end
