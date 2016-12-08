class CarriersController < ApplicationController
  before_action :set_carrier, only: [:show]

  # GET /carriers
  # GET /carriers.json
  def index
    @carriers = Carrier.all
  end

  # GET /carriers/1
  # GET /carriers/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carrier
      @carrier = Carrier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carrier_params
      params.fetch(:carrier, {})
    end
end
