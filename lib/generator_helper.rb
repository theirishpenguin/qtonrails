module GeneratorHelper

  def model_columns(a_class)
    cols = nil

    if a_class.respond_to? :columns # it's an ActiveRecord object
      cols = a_class.columns.reject{|col| ['id', 'created_at', 'updated_at'].include? col.name }
      cols.map! {|col| {'name' => col.name, 'type' => col.type}}
    else # ActiveResource object
      remote_resources_config = "vendor/plugins/qtonrails/config/remote_resources.rb"
      if File.exists?(remote_resources_config)
        serialized_obj = File.read remote_resources_config
        if serialized_obj.empty? # In case file is blank
          raise "Remote resources file is empty (#{remote_resources_config})"
        end
        remote_resources = eval(serialized_obj)
        a_resource_definition = remote_resources[a_class.name]
        non_id_fields = a_resource_definition['fields'].reject do |field|
          [a_resource_definition['id_field'], 'created_at', 'updated_at'].include? field.keys.first
        end
        cols = non_id_fields.map{|field| {'name' => field.keys.first, 'type' => field.values.first.to_sym}}
      else
        raise "No remote resources file found (#{remote_resources_config})"
      end

    end

    cols
  end

end
