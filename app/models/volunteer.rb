class Volunteer < ApplicationRecord
  has_many :inscriptions
  has_many :events, through: :inscriptions

  def full_name
    first_name + ' ' + last_name
  end
end
