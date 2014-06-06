class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
      # Sign the user in and redirect to the user's show page.
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
      # Create an error message and re-render the signin form.
      
      # if we use flash[:error] only the result is that the flash message persists one request longer than we want. 
      #For example, if we submit invalid information, the flash is set and gets displayed on the signin page;
      # if we then click on another page, such as the Home page, that’s the first request since the form submission,
      # and the flash gets displayed again, therefore F
      
    end     
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end  
  
end
