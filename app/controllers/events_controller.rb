# PUBLIC
class EventsController < ApplicationController
  def index
    date = [Date.new(2017, 12, 1), Date.today].max
    month = params[:month].presence ||
            l(date, format: '%B %Y').humanize
    month = month.sub('Décembre', 'Dec').sub('Février', 'Feb')

    @from_date = month.to_date.beginning_of_month
    @to_date = month.to_date.end_of_month

    if cookies.signed[:hiver_solidaire_id].present?
      id = cookies.signed[:hiver_solidaire_id].scan(/\d+$/).first
      volunteer = Volunteer.find_by(id: id)
      @current_user = volunteer if volunteer.present?
    end
  end
end
