module Api
  class PeopleController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_person, only: [:show]

    # GET /people/1
    def show
      render json: @person
    end

      # GET /api/inactive_users.csv?status=inactive&duration=3
   def inactive_users
         @people = Person.inactive_users(params[:status],params[:duration])
         respond_to do |format|
           format.json { render json: @people}
           format.csv { send_data @people.to_csv, filename: "inactive_users.csv"}
        end
   end

   def profiles
     profile_type = params[:type]

     if profile_type.eql? "teamleader"
       @membership = Membership.leadership
          respond_to do |format|
             format.json { render json: @membership}
             format.csv { send_data @membership.to_csv, filename: "teamleaders.csv"}
          end
      elsif profile_type.eql? "delete"
            email = params[:emailaddress]
            remove(email)
      elsif profile_type.eql? 'all'
          @people = Person.all.select("email,given_name,surname,slug")
          respond_to do |format|
             format.json { render json: @people}
             format.csv { send_data @people.to_csv}
          end
      else
         send_data "The URL is not resolving to any action. Please check!"
     end
   end


    private

    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.friendly.includes(:groups).find(params[:id])
    end

    def remove(email)
       if email.to_s.empty?
         send_data "Please provide valid email value"
       else
            begin
              Person.find_by! email: email
            rescue
              return send_data "No such user exist!!"
            end
              puts "Person found...."
              Person.admin_delete(email)
              respond_to do |format|
                  format.json { render json: {message: "Person deleted successfully"}, status: 200}
              end
       end
   end
end
end
