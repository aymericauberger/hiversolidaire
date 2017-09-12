module EventsHelper
  def email_content(date, responsable)
    content = "Bonjour à tous,\n\nVous êtes inscrits pour la soirée du #{l(@date, format: :long)}, merci beaucoup pour votre engagement!\n\n"

    content += "Le responsable de soirée est #{responsable.full_name}.\nLe responsable de soirée doit arriver à 20h (ou un peu avant) afin d’ouvrir la porte, en effet il est le seul à avoir le code de la porte d’entrée.\nCe code est communiqué via un message séparé est doit rester secret.\n\n" if responsable

    content += "Voici les coordonnées des bénévoles pour la soirée :\n\n"

    events = Event.where(start_date: date).where('events.event_type = ?', 'Diner') +
             Event.where(start_date: date).where('events.event_type = ?', 'Nuit') +
             Event.where(start_date: date + 1).where('events.event_type = ?', 'Petit-dejeuner') +
             Event.where(start_date: date + 1).where('events.event_type = ?', 'Menage')
    events.each do |event|
      if event.event_type == "Petit-dejeuner"
        content += "Et voici les coordonnées des bénévoles pour le lendemain :\n\n"
        content += "Petit-déjeûner du #{l(event.start_date, format: :long)} :\n"
      elsif event.event_type == "Diner"
        content += "Dîner du #{l(event.start_date, format: :long)} :\n"
      elsif event.event_type == "Nuit"
        content += "Nuit du #{l(event.start_date, format: :long)} au #{l(event.start_date + 1.day, format: :long)} :\n"
      elsif event.event_type == "Menage"
        content += "Ménage du #{l(event.start_date, format: :long)} :\n"
      end

      if event.event_type == 'Diner'
        inscriptions_sans_plats = event.inscriptions.where(type_de_plat: nil)
        inscriptions_sans_plats.each do |inscription|
          content += inscription.volunteer.full_name
          content += " (#{inscription.plat})" if inscription.plat.present?
          content += " (Resp.)" if inscription.responsable
          content += " | #{inscription.volunteer.phone} | #{inscription.volunteer.email}"
          content += "\n"
        end

        inscriptions_nuit = Inscription.where(event: Event.find_by(start_date: date, event_type: "Nuit"), vient_au_diner: true)
        inscriptions_nuit.each do |inscription_nuit|
          content += inscription_nuit.volunteer.full_name + " (reste la nuit)\n"
        end
        # content += "--------------------------\n" if inscriptions_sans_plats.present? || inscriptions_nuit.present?

        ['Entrée', 'Plat principal', 'Dessert', 'Pain + Fromage'].each do |type_de_plat|
          content += type_de_plat + ' : '
          if inscription = event.inscriptions.find_by(type_de_plat: type_de_plat)
            content += inscription.volunteer.full_name
            content += " (#{inscription.plat})" if inscription.plat.present?
            content += " (Resp.)" if inscription.responsable
            content += " | #{inscription.volunteer.phone} | #{inscription.volunteer.email}"
          end
          content += "\n"
        end
        # content +=  "--------------------------\n"
      else
        if event.inscriptions.present?
          event.inscriptions.each do |inscription|
            content += "#{inscription.volunteer.full_name} | #{inscription.volunteer.phone} | #{inscription.volunteer.email}\n"
          end
        end
      end
      content += "\n"
    end
    content + "Toutes les personnes ayant renseigné une adresse de courriél reçoivent ce message.
Par contre, le responsable de soirée doit contacter les personnes n’ayant pas renseigné d’adresse de courriél.

Enfin, voici la liste de personnes accueillies :

Bruno, Christian, Jean-Louis, Valentin

Quelques rappels :
- Les bénévoles de la soirée doivent ramener avec eux les restes, sauf si les accueillis s’engagent à les prendre pour déjeuner le lendemain (car on ne peut pas stocker des restes ad infinitum)

- Les bénévoles du petit déjeuner doivent prendre note des coordonnées des bénévoles de la nuit afin de les appeler en arrivant le matin pour qu’ils ouvrent la porte (ça sert aussi de réveil de dernière minute)

- Les accueillis doivent participer aux tâches ménagères : préparation de la table, vaisselle, ménage avant de partir, et pourquoi pas la cuisine s’ils le souhaitent!

- Les bénévoles du matin veillent à ce que les locaux soient propres avant de partir.

- Le lien pour le Calendrier d’inscriptions ne doit surtout pas faire objet des fuites qui pourraient permettre aux accueillis d’y avoir accès.

Merci d’avance!"
  end

  def email2_content(date, responsable)
    content = "Bonjour,\n\nVous êtes responsable de soirée pour le #{l(@date, format: :long)}, merci beaucoup pour votre engagement!\n\n"

    content += "Vos tâches :
-  Le responsable de soirée doit arriver à 20h (ou un peu avant) afin d’ouvrir la porte, en effet il est le seul à avoir le code de la porte d’entrée.
Le code est 0576 et il doit absolument rester secret, car c’est la garantie du bon fonctionnement de l’opération.
Cela rassure aussi les accueillis savent que leurs affaires sont en sécurité.\n\n"

    content += "- Vérifier le calendrier le #{l(@date, format: :long)} afin de :
   - Vérifier s’il n’y a pas de nouveaux inscrits : nécessaire pour prévoir les quantités pour le dîner.
   - Prendre en considération les commentaires de la soirée précédente (voir la colonne “Commentaires” du Calendrier d’inscriptions)

- Communiquer le nombre d’accueillis présents lors du dîner aux bénévoles du petit déjeuner afin de leur permettre de prévoir les quantités.

- Signaler s’il manque quelque chose (sac poubelle, liquide vaisselle, essuie mains, papier toilettes, etc.) : utiliser le champ “Laisser un commentaire”

- Signaler si un accueilli ne se présente pas, s’il arrive en retard, etc. : utiliser le champ “Laisser un commentaire”

- Veiller au bon déroulement de la soirée, en particulier, vérifier les horaires d’arrivée des accueillis, leur présence, ainsi que leur rappeler la charte d’Hiver Solidaire (voir le Guide du Bénévole, page 5) si besoin.

Merci d’avance!"
  end

end
