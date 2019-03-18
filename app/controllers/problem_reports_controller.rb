require 'notifications/client'

class ProblemReportsController < ApplicationController
  skip_before_action :ensure_user

  def create
    problem_report = ProblemReport.new(problem_report_params)
    
    client = Notifications::Client.new(Rails.application.config.notify_api_key)
    response = client.send_email(
      email_address: Rails.application.config.support_email,
      template_id: 'd71ae7a5-7dd4-44d3-a713-aa79aeb0e4b2',
      personalisation: {
        email: problem_report.person_email || '',
        person_id: problem_report.person_id || '',
        ip: problem_report.ip_address,
        browser: problem_report.browser,
        timestamp: problem_report.reported_at,
        goal: problem_report.goal || '',
        problem: problem_report.problem || ''
      }
    )

    notice('report_sent')
    redirect_to valid_return_path_or_login
  end

  private

  # This method returns the path that the user came here from, unless it was from a path
  # which doesn't exist within the application, or from the /auth/gplus path (which would
  # cause a CSRF error). In either of these cases we redirect to the login page.
  #
  def valid_return_path_or_login
    return_path = request.env['HTTP_REFERER']
    begin
      path_hash = Rails.application.routes.recognize_path(return_path)
      return_path = new_sessions_path if path_hash[:provider] == 'google_oauth2'
    rescue ActionController::RoutingError
      return_path = new_sessions_path
    end
    return_path
  end

  def problem_report_params
    params.require(:problem_report).
      permit(:goal, :problem, :browser, :person_email).
      merge(current_user_params).
      merge(ip_address: request.remote_ip)
  end

  def current_user_params
    if logged_in_regular?
      { person_email: current_user.email, person_id: current_user.id }
    else
      {}
    end
  end
end
