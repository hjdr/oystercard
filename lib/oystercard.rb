require './lib/station.rb'
require './lib/journeys.rb'


class Oystercard

  attr_accessor :balance, :entry_station, :exit_station, :journeys, :journey

  BALANCE_LIMIT = 90
  MINIMUM_FARE_LIMIT = 1

  def initialize(balance=0)
    @balance = balance
    @journeys = []
    @journey = Journey.new
  end

  def top_up(amount)
    balance_check(amount)
    self.balance += amount
  end

  def balance_check(amount)
    raise("amount exceeded, balance cannot be: #{amount + self.balance}. Balance limit is 90") if (amount + self.balance) > BALANCE_LIMIT
  end

  def touch_in(train_station, journey=Journey.new)
    deduct(@journey.fare) unless @journey.complete?
    @journey = journey
    raise "Not enough funds, minimum balance required 1" if  minimum_fare_check
    @journey.start(train_station)
  end

  def touch_out(train_station)
    @journey.end(train_station)
    deduct(@journey.fare)
    store_journey
  end

  private
    def deduct(amount)
      @balance -= amount
    end

    def store_journey
      @journeys << @journey
    end

    def minimum_fare_check
      self.balance < MINIMUM_FARE_LIMIT
    end

end