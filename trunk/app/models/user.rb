require 'digest/sha1'
class User < ActiveRecord::Base

  has_many :courses, :class_name => 'Course', :foreign_key => 'creator_id'
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end

  public
  def courses_with_rating
    result = self.courses
    ratings = Course.rating_avesages_for(result.map{|course|course.id})
    result.each do |course|
      course.rating = ratings[course.id] || 0
    end
    result
  end
  
  
  extends_column :sex do
    enum do
      entry 1, :male, "男性"
      entry 2, :female, "女性"
      end
    end

  extends_column :age do
    enum do
      entry 0, :none, "指定なし"
      entry 1, :age1, "10代"
      entry 2, :age2, "20代"
      entry 3, :age3, "30代"
      entry 4, :age4, "40代"
      entry 5, :age5, "50代"
      entry 6, :age6, "60代"
      entry 7, :age7, "70代"
      entry 8, :age8, "80代"
    end
  end
  
  extends_column :address do
    enum do
      entry 1, :address1, "北海道"
      entry 2, :address2, "青森県"
      entry 3, :address3, "岩手県"
      entry 4, :address4, "宮城県"
      entry 5, :address5, "秋田県"
      entry 6, :address6, "山形県"
      entry 7, :address7, "福島県"
      entry 8, :address8, "東京都"
      entry 9, :address9, "神奈川県"
      entry 10, :address10, "埼玉県"
      entry 11, :address11, "千葉県"
      entry 12, :address12, "茨城県"
      entry 13, :address13, "栃木県"
      entry 14, :address14, "群馬県"
      entry 15, :address15, "山梨県"
      entry 16, :address16, "新潟県"
      entry 17, :address17, "長野県"
      entry 18, :address18, "富山県"
      entry 19, :address19, "石川県"
      entry 20, :address20, "福井県"
      entry 21, :address21, "愛知県"
      entry 22, :address22, "岐阜県"
      entry 23, :address23, "静岡県"
      entry 24, :address24, "三重県"
      entry 25, :address25, "大阪府"
      entry 26, :address26, "兵庫県"
      entry 27, :address27, "京都府"
      entry 28, :address28, "滋賀県"
      entry 29, :address29, "奈良県"
      entry 30, :address30, "和歌山県"
      entry 31, :address31, "鳥取県"
      entry 32, :address32, "島根県"
      entry 33, :address33, "岡山県"
      entry 34, :address34, "広島県"
      entry 35, :address35, "山口県"
      entry 36, :address36, "徳島県"
      entry 37, :address37, "香川県"
      entry 38, :address38, "愛媛県"
      entry 39, :address39, "高知県"
      entry 40, :address40, "福岡県"
      entry 41, :address41, "佐賀県"
      entry 42, :address42, "長崎県"
      entry 43, :address43, "熊本県"
      entry 44, :address44, "大分県"
      entry 45, :address45, "宮崎県"
      entry 46, :address46, "鹿児島県"
      entry 47, :address47, "沖縄県"
    end
  end  
end