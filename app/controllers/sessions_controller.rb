class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      #Sign the user in
      session[:user_id] = user.id
      redirect_to products_url, notice: "Logged in!"
    else
      #User not found or password is bad
      flash.now[:alert] = "Please check your login information and try again." #.now presents the flash, but then with the loading of the next page, it will not be present.
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to products_url, notice: "Logged out!"
  end
end
