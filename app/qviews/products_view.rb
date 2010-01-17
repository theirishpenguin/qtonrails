#TODO: Move require somewhere more appropriate
require 'app/presenters/product_qform_presenter.rb'

class ProductsView

  def edit(record)
    screen = Main.new(nil, record)
    screen.show
  end
           
end
