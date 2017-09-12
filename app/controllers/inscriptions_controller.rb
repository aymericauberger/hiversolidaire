class InscriptionsController < ApplicationController
  def show
    @inscription = Inscription.find(params[:id])
    @event = Event.find(params[:event_id])
  end

  def new
    @event = Event.find(params[:event_id])

    if cookies.signed[:hiver_solidaire_id].present? && params[:other_person].blank?
      id = cookies.signed[:hiver_solidaire_id].scan(/\d+$/).first
      @volunteer = Volunteer.find_by(id: id)
    elsif params[:premiere_connexion] || params[:other_person].present?
      @volunteer = Volunteer.new
    else
      render 'events/pop_login.js.erb'
    end
  end

  def create
    event = Event.find(params[:event_id])
    if params[:first_name].blank? || params[:last_name].blank? ||
       params[:phone].blank?
      flash[:alert] = 'Votre prénom, nom et numéro de téléphone '\
                      'sont obligatoires.'
      redirect_to new_event_inscription_path(
        event,
        other_person: params[:other_person],
        premiere_connexion: true
      )
    elsif params[:phone].gsub(/\D/, '').size < 10
      flash[:alert] = 'Votre numéro de téléphone doit contenir au moins '\
                      '10 chiffres.'
      redirect_to new_event_inscription_path(
        event,
        other_person: params[:other_person],
        premiere_connexion: true
      )
    else
      if params[:accept_save]
        volunteer = Volunteer.where(phone: params[:phone]).first_or_create
        volunteer.update(first_name: params[:first_name],
                         last_name: params[:last_name],
                         email: params[:email])
        volunteer.update(accept_save: true) if params[:accept_save]
      else
        volunteer = Volunteer.create(first_name: params[:first_name],
                                     last_name: params[:last_name],
                                     phone: params[:phone],
                                     email: params[:email])
      end

      inscription = Inscription.new(event: event, volunteer: volunteer)
      if event.event_type == 'Diner'
        inscription.type_de_plat = params[:type_de_plat]
        inscription.plat = params[:plat]
      elsif event.event_type == 'Nuit'
        inscription.vient_au_diner = params[:vient_au_diner].present?
      end
      inscription.responsable = true if params[:responsable]
      inscription.save

      if inscription.persisted?
        if volunteer.accept_save
          cookies.signed[:hiver_solidaire_id] = {
            value: [volunteer.first_name, volunteer.last_name, volunteer.id].join('-'),
            expires: 1.year.from_now
          }
        end
        if inscription.vient_au_diner
          Event.find_by(start_date: event.start_date, event_type: 'Diner').touch
        end
        if volunteer.email.present?
          UserMailer.inscription_confirmation(inscription).deliver_later
        end
        if params[:other_person].present?
          flash[:notice] = 'Merci ! Cette inscription a bien été enregistrée.'
        else
          flash[:notice] = "Merci #{volunteer.first_name} "\
                           "#{volunteer.last_name} ! Votre inscription a "\
                           'bien été enregistrée.'
        end
      else
        flash[:alert] = 'Erreur : Vous ne pouvez pas vous inscrire deux fois '\
                        'au même endroit.'
      end

      redirect_to root_path(month: l(event.start_date, format: '%B %Y').humanize)
    end
  end

  def login
    volunteer = Volunteer.where(phone: params[:phone]).order(:created_at).first
    if volunteer
      cookies.signed[:hiver_solidaire_id] = {
        value: [volunteer.first_name, volunteer.last_name, volunteer.id].join('-'),
        expires: 1.year.from_now
      }
      flash[:notice] = "Bienvenue #{volunteer.first_name} "\
                       "#{volunteer.last_name} ! Vous êtes connecté."
    else
      flash[:alert] = 'Votre numéro n’a pas été trouvé.'
    end

    if params[:event_id].present?
      redirect_to new_event_inscription_path(
        params[:event_id],
        premiere_connexion: true
      )
    else
      redirect_to root_path
    end
  end

  def logout
    cookies.delete :hiver_solidaire_id
    flash[:notice] = 'Vous êtes déconnecté.'
    redirect_to root_path
  end

  def destroy
    if cookies.signed[:hiver_solidaire_id].present?
      id = cookies.signed[:hiver_solidaire_id].scan(/\d+$/).first
      volunteer = Volunteer.find_by(id: id)
      current_user = volunteer if volunteer.present?
    end
    inscription = Inscription.find(params[:id])
    if inscription.volunteer.phone == current_user.phone
      if inscription.volunteer.email.present?
        UserMailer.desinscription_confirmation(inscription).deliver_later
      end
      if inscription.vient_au_diner
        Event.find_by(start_date: inscription.event.start_date, event_type: 'Diner').touch
      end
      inscription.destroy
      flash[:notice] = 'Votre inscription a été annulée.'
    end

    redirect_to root_path(
      month: l(inscription.event.start_date, format: '%B %Y').humanize
    )
  end
end
