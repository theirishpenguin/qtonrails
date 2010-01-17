class ProductsController

  def edit
    Product.find(Router.params[:id])
  end

end
