class Commentaire < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  validates :text, presence: true
end
