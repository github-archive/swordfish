class Invite < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :user
  belongs_to :team

  before_create do
    self.token = SecureRandom.urlsafe_base64(12)
  end

  def self.from_token(token)
    where(:token => token).first!
  end

  def self.to(team)
    where :team_id => team.id
  end

  def accept(user)
    !accepted? && update_attributes(:user_id => user.id)
  end

  def fulfill(key)
    team.add(user, key)
    destroy
  end

  def accepted?
    user_id?
  end

end
