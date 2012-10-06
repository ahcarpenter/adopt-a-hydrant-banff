# http://stackoverflow.com/questions/8212378/validate-us-zip-code-using-rails
# http://geekswithblogs.net/MainaD/archive/2007/12/03/117321.aspx
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable
  attr_accessible :address_1, :address_2, :city, :email, :name, :organization,
    :password, :password_confirmation, :remember_me, :sms_number, :area, :zip
  validates_formatting_of :email, :using => :email
  validates_formatting_of :sms_number, :using => :us_phone, :allow_blank => true
  validates_format_of :zip, :with => /^[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}$/, :allow_blank => true
  validates_presence_of :name
  has_many :reminders_to, :class_name => "Reminder", :foreign_key => "to_user_id"
  has_many :reminders_from, :class_name => "Reminder", :foreign_key => "from_user_id"
  has_many :things
  has_many :referrals
  before_validation :remove_non_digits_from_phone_numbers
  
  def remove_non_digits_from_phone_numbers
    self.sms_number = SMS.sieve(self.sms_number).to_i if self.sms_number.present?
  end
  
  def self.current
     Thread.current[:user]
  end
  
  def self.current=(user)
     Thread.current[:user] = user
  end
  
  def self.new1
    user = self.new
    user.id = (User.all.last.id) + 1 if User.any?
    user.id = 1 if !User.any?
    user.created_at = Time.now
    user.updated_at = Time.now
    User.current = user
    return user
  end

  def update1(name, id, email)
    self.name = name
    self.facebook_id = id
    self.email = email
    self.save
    User.current = self
  end
end