class JourneyLog
  attr_reader :journey
  def initialize(journey_class: Journey.new)
    @journey = journey_class
    @history = []
  end

  def start(station, journey = Journey.new)
    @journey = journey
    @journey.start(station)
  end

  def finish(station)
    @journey.end(station)
    @history << @journey
  end

  def history
    @history.clone
  end
end