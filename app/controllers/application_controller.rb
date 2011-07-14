class ApplicationController < ActionController::Base
  before_filter :authorize  
  before_filter :admin_required
  after_filter  :save_referer
  protect_from_forgery

  protected
    def authorize
      unless User.find_by_id(session[:user_id])
        redirect_to login_url, :notice => "Please log in"
      end
    end
    
    def admin_required  
      current_user = User.find_by_id(session[:user_id])
      if (current_user == nil) || (current_user.role != 1)
        redirect_to request.env["HTTP_REFERER"], :notice => "You have no permissions to access this page"  
      end  
    end 

    def save_referer
      session['referer'] = request.env["HTTP_REFERER"]
    end
end
