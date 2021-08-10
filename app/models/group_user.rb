class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user
  
  def self.admin_or_dm?(user)
    !user.nil? && (user.admin? || user.dm?)
  end

  def self.admin?(user)
    !user.nil? && user.admin?
  end

  def self.able_to_send_request_to_join?(group, user, current_user)
    (group.users.length < group.party_size) && user.nil? && !Invitation.where(group_id: group.id, sender_id: current_user.id).exists?
  end
end
