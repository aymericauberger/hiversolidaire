module Admin
  # ADMIN
  class EventsController < Admin::BaseController
    def index
      @start_date = Constants::START_DATE
      date = [@start_date, Date.today].max
      month = params[:month].presence ||
              l(date, format: '%B %Y').humanize
      month = month.sub('Décembre', 'Dec').sub('Février', 'Feb')

      @from_date = [@start_date, month.to_date.beginning_of_month].max
      @to_date = month.to_date.end_of_month
    end

    def auto_emails
      @date = Date.parse(params[:date])
      @diner = Event.find_by(start_date: @date, event_type: 'Diner')
      inscription_responsable = @diner.inscriptions.find_by(responsable: true)
      if inscription_responsable.blank?
        flash[:alert] = "Il n'y a pas de responsable pour cette date."
        return redirect_to admin_events_path(
          month: l(@diner.start_date, format: '%B %Y').humanize
        )
      end
      @responsable = inscription_responsable.volunteer if inscription_responsable
      if @responsable.email.blank?
        flash[:alert] = "Le responsable pour cette date n'a pas renseigné son email."
        return redirect_to admin_events_path(
          month: l(@diner.start_date, format: '%B %Y').humanize
        )
      end
      @email_subject = "Soirée Hiver Solidaire du #{l(@date, format: :long)}"
      recipients = Event.where(start_date: @date)
                        .where.not(event_type: 'Petit-dejeuner')
                        .joins(:inscriptions)
                        .joins(:volunteers)
                        .pluck('volunteers.email') +
                  Event.where(start_date: @date + 1)
                        .where(event_type: 'Petit-dejeuner')
                        .joins(:inscriptions)
                        .joins(:volunteers)
                        .pluck('volunteers.email')
      @email_recipients = recipients.reject { |c| c.empty? }.uniq

      @email2_subject = "Soirée Hiver Solidaire du #{l(@date, format: :long)} "\
                        '(Note au responsable)'
      @email2_recipient = @responsable.email unless @diner.mail_sent

      if request.method == 'POST'
        UserMailer.recapitulatif_soiree(
          params[:email_subject],
          params[:email_content], @email_recipients
        ).deliver_later
        UserMailer.recapitulatif_soiree(
          params[:email2_subject],
          params[:email2_content], @email2_recipient
        ).deliver_later
        flash[:notice] = 'Emails envoyés !'
        @diner.update(mail_sent: true)
        redirect_to admin_events_path(
          month: l(@diner.start_date, format: '%B %Y').humanize
        )
      end
    end

    def custom_action
      # Inscription.destroy_all
      # Event.destroy_all

      # (1..31).each do |i|
      #   Event.create!(event_type: 'Diner', start_date: Date.new(2017, 12, i))
      #   Event.create!(event_type: 'Nuit', start_date: Date.new(2017, 12, i))
      #   Event.create!(
      #     event_type: 'Petit-dejeuner',
      #     start_date: Date.new(2017, 12, i)
      #   )
      #   if l(Date.new(2017, 12, i), format: '%A') == 'samedi'
      #     Event.create!(event_type: 'Menage', start_date: Date.new(2017, 12, i))
      #   end
      # end

      # (1..31).each do |i|
      #   Event.create!(event_type: 'Diner', start_date: Date.new(2018, 1, i))
      #   Event.create!(event_type: 'Nuit', start_date: Date.new(2018, 1, i))
      #   Event.create!(
      #     event_type: 'Petit-dejeuner',
      #     start_date: Date.new(2018, 1, i)
      #   )
      #   if l(Date.new(2018, 1, i), format: '%A') == 'samedi'
      #     Event.create!(event_type: 'Menage', start_date: Date.new(2018, 1, i))
      #   end
      # end

      # (1..28).each do |i|
      #   Event.create!(event_type: 'Diner', start_date: Date.new(2018, 2, i))
      #   Event.create!(event_type: 'Nuit', start_date: Date.new(2018, 2, i))
      #   Event.create!(
      #     event_type: 'Petit-dejeuner',
      #     start_date: Date.new(2018, 2, i)
      #   )
      #   if l(Date.new(2018, 2, i), format: '%A') == 'samedi'
      #     Event.create!(event_type: 'Menage', start_date: Date.new(2018, 2, i))
      #   end
      # end

      (1..15).each do |i|
        Event.create!(event_type: 'Diner', start_date: Date.new(2018, 3, i))
        Event.create!(event_type: 'Nuit', start_date: Date.new(2018, 3, i))
        Event.create!(
          event_type: 'Petit-dejeuner',
          start_date: Date.new(2018, 3, i)
        )
        if l(Date.new(2018, 3, i), format: '%A') == 'samedi'
          Event.create!(event_type: 'Menage', start_date: Date.new(2018, 3, i))
        end
      end

      redirect_to :admin_events_index
    end
  end
end
