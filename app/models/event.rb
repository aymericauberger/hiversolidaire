class Event < ApplicationRecord
  has_many :inscriptions
  has_many :volunteers, through: :inscriptions

  validates :start_date, presence: true, uniqueness: { scope: :event_type }

  def custom_order
    if event_type == 'Petit-dejeuner'
      start_date + 0.5
    elsif event_type == 'Diner'
      start_date + 0.6
    elsif event_type == 'Nuit'
      start_date + 0.7
    elsif event_type == 'Menage'
      start_date + 0.8
    end
  end

  def human_name
    if event_type == "Petit-dejeuner"
      "le petit-déjeûner du #{I18n.l(start_date, format: :long)}"
    elsif event_type == "Diner"
      "le dîner du #{I18n.l(start_date, format: :long)}"
    elsif event_type == "Nuit"
      "la nuit du #{I18n.l(start_date, format: :long)} au "\
      "#{I18n.l(start_date + 1.day, format: :long)}"
    elsif event_type == "Menage"
      "le ménage du #{I18n.l(start_date, format: :long)}"
    end
  end
end
