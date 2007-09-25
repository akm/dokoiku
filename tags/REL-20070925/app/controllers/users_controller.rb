require 'json'
class UsersController < ApplicationController
  
  PUBLISHED_FIELDS = [:login, :email, :created_at, :updated_at]
  DEFAULT_XML_OPTIONS = {:only => PUBLISHED_FIELDS}

  def to_hash(user)
    if user.is_a?(Array)
      return user.map{|user|to_hash(user)}
    elsif user.is_a?(User)
      {:login => user.login, :email => user.email, :created_at => user.created_at, :updated_at => user.updated_at}
    else
      user
    end
  end
    
  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @users.to_xml(DEFAULT_XML_OPTIONS) }
      format.json { render :json => to_hash(@users).to_json}
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    if params[:login] and params[:password]
      @user = User.authenticate(params[:login], params[:password])
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => (@user || User.new).to_xml(DEFAULT_XML_OPTIONS)}
        format.json { render :json => to_hash(@users).to_json}
      end
    else
      @user = User.find(params[:id])
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @user.to_xml(DEFAULT_XML_OPTIONS) }
        format.json { render :json => to_hash(@user).to_json}
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1;edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to user_url(@user) }
        format.xml  { head :created, :location => user_url(@user) }
        format.json { render :json => to_hash(@user).to_json }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors.to_xml }
        format.json { render :json => @user.errors.full_messages.to_json }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to user_url(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.xml  { head :ok }
    end
  end
end
