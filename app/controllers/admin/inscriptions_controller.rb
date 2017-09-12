class Admin::InscriptionsController < Admin::BaseController
  require 'csv'

  def edit
    @event = Event.find(params[:event_id])
    @inscription = Inscription.find(params[:id])
  end

  def update
    event = Event.find(params[:event_id])
    volunteer = Volunteer.where(first_name: params[:first_name], last_name: params[:last_name], phone: params[:phone]).first_or_create
    volunteer.update(email: params[:email])

    inscription = Inscription.find(params[:id])
    inscription.volunteer = volunteer
    if event.event_type == 'Diner'
      inscription.type_de_plat = params[:type_de_plat]
      inscription.plat = params[:plat]
    end
    if params[:responsable]
      inscription.responsable = true
    elsif event.event_type == 'Diner'
      inscription.responsable = false
    end

    if params[:vient_au_diner]
      inscription.vient_au_diner = true
    elsif event.event_type == 'Nuit'
      inscription.vient_au_diner = false
    end
    inscription.save

    if event.event_type == 'Nuit'
      Event.find_by(start_date: event.start_date, event_type: 'Diner').touch
    end

    redirect_to admin_events_path(
      month: l(event.start_date, format: '%B %Y').humanize
    )
  end

  def destroy
    inscription = Inscription.find(params[:id])
    inscription.destroy
    flash[:notice] = "Inscription annulée."
    redirect_to admin_events_path(
      month: l(inscription.event.start_date, format: '%B %Y').humanize
    )
  end

  def export
    respond_to do |format|
      format.html
      format.csv do
        send_data(
          Inscription.to_csv,
          filename: "Hiver Solidare export #{Date.today}.csv"
        )
      end
    end
  end
end
