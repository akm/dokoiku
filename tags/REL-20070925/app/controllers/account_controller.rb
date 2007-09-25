class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end

  def login_redirect
    return unless request.post?
    login_member = params[:members]
    
    self.current_user = User.authenticate(login_member[:login_id], login_member[:pw])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      flash[:notice] = "Logged in successfully"
    end
    redirect_to params[:request_from]
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/course', :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(:controller => '/course', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in? and !self.current_user.frozen?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/recommend', :action => 'question')
  end
  
  def mypage
    @user = current_user
    if @user
      render :action => 'mypage'
    else
      redirect_to(:controller=> 'recommend', :action => 'question') 
    end
  end

  def edit_profile
    @user = current_user
    unless @user
      redirect_to(:controller=> 'recommend', :action => 'question') 
      return
    end
    if request.get?
      render :action => 'edit_profile'
    else
      user_attr = params[:user].dup
      if user_attr[:password].blank?
        user_attr.delete(:password)
        user_attr.delete(:password_confirmation)
      end
      @user.attributes = user_attr
      @user.save
      render :action => 'edit_profile'
    end
  end
  
  def resign
    unless logged_in?
      redirect_to(:controller=> 'recommend', :action => 'question') 
      return
    end
    if request.get?
      render :action => 'resign'
    else
      current_user.destroy
      logout
    end
  end
  
  def privacy
    render :partial => 'account/privacy'
  end
  
end
