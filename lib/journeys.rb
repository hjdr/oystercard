

class Journey

  attr_reader :entry_station, :exit_station, :journeys
  MINIMUM_FARE = 1
  PENALTY = 6

  def initialize
    @journeys = []
  end

  def start(station)
    @entry_station = station
  end

  def end(station)
    @exit_station = station
  end

  def complete?
    !@entry_station.nil? && !@exit_station.nil? 
  end

  def fare
    complete? ? MINIMUM_FARE : PENALTY
  end

  def entry_check_fine?
    !@entry_station.nil? && @exit_station.nil? 
  end

end