module Api
  class PeopleController < ApplicationController
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
           format.csv { send_data @people.to_csv}
        end
   end



    private

    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.friendly.includes(:groups).find(params[:id])
    end

  end
end
