class User < ActiveRecord::Base
  has_many :roles

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :excluding_archived, ->() { where(archived_at: nil) }

  def to_s
    "#{email} (#{admin? ? "Admin" : "User"})"
  end

  def archive
    self.update(archived_at: Time.now)
  end

  def active_for_authentication?
    # Prevent archived users signing in
    # super required for other checks (account locked, etc.)
    super && archived_at.nil?
  end

  def inactive_message
    # Return archived error message if user is archived
    # symbol used for localisation
    # see config/locales/devise.en.yml
    archived_at.nil? ? super : :archived
  end

  def role_on(project)
    roles.find_by(project_id: project).try(:name)
  end
end
