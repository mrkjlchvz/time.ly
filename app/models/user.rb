class User < ActiveRecord::Base
  validates :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  has_many :reminders, dependent: :destroy

  def self.from_omniauth auth_hash, token
    user = self.find_or_create_by(provider: auth_hash.provider, uid: auth_hash.uid) do |u|
      u.email = auth_hash.info.email
      u.name = auth_hash.info.name
      u.image = auth_hash.info.image
      u.access_token = token
    end

    user
  end
end
