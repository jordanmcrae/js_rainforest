class ProductsController < ApplicationController
  before_filter :ensure_logged_in, only: [:edit, :destroy, :create]

  def index
    @products = if params[:search]
      Product.where("LOWER(name) LIKE LOWER(?)", "%#{params[:search]}%")  #Case insensitive search
    else
      Product.all
    end

    @products = @products.order('products.created_at DESC').page(params[:page]) #page method given to us by Kaminari to assist in pagination

    # if request.xhr?     #Since 'X-Requested-With=XMLHTTPRequest' is passed with each request, request.xhr? method can be used (Rails knows this is an AJAX request)
    #   render @products
    # end

    respond_to do |format|  #Now it will look for index.js.erb -- Must create a view.
      format.html do
        if request.xhr?         #Strictly respond to html and js
          render @products      #Instead of rendering a whole page, it renders the partial,
        end
        #render 'index.html.erb'
      end
      format.js   #render 'index.js.erb'
    end
  end

  def show
    @product = Product.find(params[:id])

    if current_user
      @review = @product.reviews.build
    end
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_url

    else
      render :new
    end
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(product_params)
      redirect_to product_path(@product)
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
      redirect_to products_path
  end

  private
  def product_params
    params.require(:product).permit(:name, :description, :price_in_cents)
  end

end
