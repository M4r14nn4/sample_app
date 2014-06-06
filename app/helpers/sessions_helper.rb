module SessionsHelper
  
  def sign_in(user)
    remember_token = User.new_remember_token #we create a new token
    cookies.permanent[:remember_token] = remember_token #place the raw token in the browser cookies
    
    #The pattern of setting a cookie that expires 20 years in the future became so common that Rails added a 
    #special permanent method to implement it, so that we can simply write cookies.permanent[:remember_token] = remember_token
    
    user.update_attribute(:remember_token, User.digest(remember_token)) #save the hashed token to the db
   
    # update_attribute method allows us to update a single attribute while bypassing the validations - necessary in this case since
    # we don't have the user's psw or confirmation 
   
    self.current_user = user #set the current user equal to the given user
  end
  
  #A user is signed in if there is a current user in the session, i.e., if current_user is non-nil.
  def signed_in?
    !current_user.nil?
  end  
      
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    #because the remember token in the database is hashed, we first need to hash the token 
    #from the cookie before using it to find the user in the database
    remember_token = User.digest(cookies[:remember_token])
    
    #set the @current_user instance variable to the user corresponding to the remember token, 
    #but only if @current_user is undefined.
    
    @current_user ||= User.find_by(remember_token: remember_token)
    
    #calls the find_by method the first time current_user is called, but on subsequent invocations 
    #returns @current_user without hitting the database.
  end
  
  def sign_out(user)
    
    #first change the user’s remember token in the database 
    current_user.update_attribute(:remember_token,
                                      User.digest(User.new_remember_token))
    
    # use the delete method on cookies to remove the remember token from the session
    cookies.delete(:remember_token)
    
    #set the current user to nil
    self.current_user = nil
    
  end  
  
end
