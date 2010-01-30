class QmainwindowGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      qform_dir = 'vendor/plugins/qtonrails/app/qforms'
      m.directory qform_dir
      m.template('ui/qmainwindow_template.ui', "#{qform_dir}/qmainwindow.ui")

      ui_f = qform_dir + '/qmainwindow.ui'
      ui_proxy_filepath = ui_f.gsub('qforms', 'ui_proxies') + '.rb'

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
