class Inscription < ApplicationRecord
  belongs_to :volunteer
  belongs_to :event, touch: true

  validates :event_id, presence: true
  validates :volunteer_id, presence: true, uniqueness: { scope: :event_id }

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ['Date',
              'Type',
              'Inscriptions - Prénom',
              'Nom',
              'Téléphone',
              'Email',
              'Type de plat',
              'Plat (détail)',
              'Responsable ?',
              'Vient au diner ?',
              'Commentaires']

      Event.all.sort_by(&:custom_order).each do |event|
        commentaire = Commentaire.find_by(date: event.start_date)
        commentaire_text = commentaire && event.event_type == 'Diner' ? commentaire.text : ''
        if event.inscriptions.present?
          event.inscriptions.each do |inscription|
            csv << ["'#{event.start_date}'",
                    event.event_type,
                    inscription.volunteer.first_name,
                    inscription.volunteer.last_name,
                    inscription.volunteer.phone,
                    inscription.volunteer.email,
                    inscription.type_de_plat,
                    inscription.plat,
                    inscription.responsable,
                    inscription.vient_au_diner,
                    commentaire_text]
            commentaire_text = ''
          end
        else
          csv << ["'#{event.start_date}'", event.event_type, '', '', '', '', '', '', '', commentaire_text]
        end
      end

    end
  end
end
