class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :messages, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :games, dependent: :destroy
  has_one_attached :image

  def seats
    seats_available = self.party_size - self.group_users.length

    "#{seats_available} #{seats_available == 1 ? "Seat" : "Seats"}"
  end

  def allies
    allies = self.group_users.length

    "#{allies} #{allies == 1 ? "Ally" : "Allies"}"
  end
end
