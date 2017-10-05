class UserMailer < ApplicationMailer
  default from: "#{ENV['APP_NAME']} <#{ENV['EMAIL_CONTACT']}>"

  def inscription_confirmation(inscription)
    @inscription = inscription
    @event = inscription.event
    mail(
      to: inscription.volunteer.email,
      subject: "Hiver Solidaire : confirmation d'inscription (#{l(@event.start_date, format: :long)})"
    )
  end

  def desinscription_confirmation(inscription)
    @inscription = inscription
    @event = inscription.event
    mail(
      to: inscription.volunteer.email,
      subject: "Hiver Solidaire : confirmation de désinscription (#{l(@event.start_date, format: :long)})"
    )
  end

  def recapitulatif_soiree(subject, content, recipients)
    @content = content
    mail(to: recipients, subject: subject)
  end
end
