require 'fileutils'

class QactiveresourceGenerator < Rails::Generator::Base

  def manifest

    record do |m|

        qactive_resources = {}
        # Extract any qactiveresource arguments, eg. taking Search from the following...
        # ./script/generate qactiveresource Search:"http://example.com"[xml,/search.xml?q=ebi,id:integer,name:string,description:text]
        args.each do |arg|
          if arg.include? '['
            name_and_url, definition = arg.split('[')
            definition.chomp!(']')
    
            qactive_resource = {}
    
            name_and_url_pieces = name_and_url.split(':')
            qactive_resource_name = name_and_url_pieces.shift 
            qactive_resource['site'] = name_and_url_pieces.join(':')
    
            format, query, *named_attribs = definition.split(',')
            qactive_resource['format'] = format
            qactive_resource['query'] = query
    
            fields = []
            named_attribs.each do |attr|
              name_and_value = attr.split(':')
              fields << {name_and_value[0] => name_and_value[1]}
            end
    
            qactive_resource['fields'] = fields
            
            qactive_resources[qactive_resource_name] = qactive_resource
          end
        end
    
        qtr_dir = 'vendor/plugins/qtonrails'
        models_dir = 'app/models'
        qconfig_dir = "#{qtr_dir}/config"
        remote_resources_config = "#{qconfig_dir}/remote_resources.rb"
    
        qactive_resources.each_pair do |name, details|
          model_file_name = "#{name.underscore}.rb"
          puts "Deleting old #{models_dir}/#{model_file_name}"
          `rm #{models_dir}/#{model_file_name}`
          m.template('active_resource.rb.template', "#{models_dir}/#{model_file_name}", :assigns => {:resource_name => name, :site => details['site'] } )
        end
    
        if File.exists?(remote_resources_config)
          serialized_obj = File.read remote_resources_config
          serialized_obj = '{}' if serialized_obj.empty? # In case file is blank
          remote_resources = eval(serialized_obj)
        else
          remote_resources  = {}
        end
    
        remote_resources.merge! qactive_resources
    
        File.open(remote_resources_config, 'w') {|f| f.write(remote_resources.inspect) }
      end

    end

end
