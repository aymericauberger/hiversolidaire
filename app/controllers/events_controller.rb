class EventsController < ApplicationController
  def index
    if params[:month].blank?
      month = l(Date.today, format: '%B %Y').humanize
    else
      month = params[:month]
    end

    @from_date = I18n.transliterate(month).to_date.beginning_of_month
    @to_date = I18n.transliterate(month).to_date.end_of_month

    if cookies.signed[:hiver_solidaire_id].present?
      id = cookies.signed[:hiver_solidaire_id].scan(/\d+$/).first
      volunteer = Volunteer.find_by(id: id)
      @current_user = volunteer if volunteer.present?
    end
  end
end
