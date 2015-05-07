class ReviewsController < ApplicationController
    before_filter :load_product
    before_filter :ensure_logged_in

  def show
    @review = Review.find(params[:id])
  end

  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    respond_to do |format|
      if @review.save
        format.html { redirect_to product_path(@product.id), notice: 'Thank you for your review.' }
        format.js {} # This will look for app/views/reviews/create.js.erb
      else
        format.html { render 'products/show', alert: 'There was an error.'}
        format.js {}
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
  end

  private

  def review_params
    params.require(:review).permit(:comment, :product_id)
  end

  def load_product
    @product = Product.find(params[:product_id])
  end
end
