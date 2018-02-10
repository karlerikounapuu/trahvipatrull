class SpeedtrapController < ApplicationController
  def index
  	@speedtraps = Speedtrap.fetchlive.as_json
  	render json: JSON.pretty_generate(@speedtraps)
  end
end
