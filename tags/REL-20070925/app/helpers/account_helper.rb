module AccountHelper
  
  def user(key)
    send("user_#{key}")
  rescue
    @user.send(key)
  end
  
end