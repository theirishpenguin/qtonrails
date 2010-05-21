class KmainwindowGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      qdesigns_dir = 'vendor/plugins/qtonrails/app/qdesigns'
      m.directory qdesigns_dir
      m.template('ui/kmainwindow_template.ui', "#{qdesigns_dir}/kmainwindow.ui")

      ui_f = qdesigns_dir + '/kmainwindow.ui'
      ui_proxy_filepath = ui_f.gsub('qdesigns', 'ui_proxies') + '.rb'

      command = %^rbuic4 "#{RAILS_ROOT}/#{ui_f}" -x -o "#{ui_proxy_filepath}"^

      puts command

      system command

      # This is a little more rigid and hardcoded than
      # non-main window presenters
      qpresenters_dir = 'vendor/plugins/qtonrails/app/qpresenters'
      m.directory qpresenters_dir
      m.template('main_window_presenter.rb', "#{qpresenters_dir}/main_window_presenter.rb")

    end
  end

end
