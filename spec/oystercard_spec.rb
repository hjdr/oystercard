require 'oystercard'

describe Oystercard do

  let(:euston) { double('euston') }
  let(:kingscross) { double('trainstation1') }

  before :each do
    allow(euston).to receive(:name).and_return('euston')
    allow(euston).to receive(:zone).and_return(1)
    allow(kingscross).to receive(:name).and_return('kingscross')
    allow(kingscross).to receive(:zone).and_return(2)
  end

  describe "#initialize" do
    it "creates an empty journeys list" do
      expect(subject.journeys).to be_empty
    end

    it "sets balance to 0" do
      expect(subject.balance).to eq 0
    end
  end

  describe "#top_up" do
    it "adds money to the balance" do
      subject.top_up(20)
      expect(subject.balance).to eq 20
    end

    it "raises an error if combined balance > BALANCE_LIMIT" do
      card = Oystercard.new
      expect { card.top_up(95) }.to raise_error("amount exceeded, balance cannot be: 95. Balance limit is 90")
    end
  end

  describe "#touch_in" do
    context "with sufficient funds" do
      it "records the entry_station" do
        subject.top_up(20)
        subject.touch_in(euston)
        expect(subject.entry_station).to eq(euston)
      end
    end

    context "with insufficient funds" do
      it "raises an error message" do
        expect { subject.touch_in(euston) }.to raise_error "Not enough funds, minimum balance required 1"
      end
    end
  end

  describe "#touch_out" do

    before :each do
      subject.top_up(20)
      subject.touch_in(euston)
    end

    it "records the exit station" do
      subject.touch_out(kingscross)
      expect(subject.exit_station).to eq(kingscross)
    end
    
    it "charges the minimum balance" do
      expect {subject.touch_out(kingscross)}.to change{subject.balance}.by(-1)
    end
  end

  describe "#in_journey?" do
    
    before :each do
      subject.top_up(20)
      subject.touch_in(euston)
    end

    it "returns the oyestercard is in use" do
      expect(subject.in_journey?).to eq true
    end

    it "returns the oystercard is not in use" do
      subject.touch_out(kingscross)
      expect(subject.in_journey?).to eq false
    end
  end

  describe "#minimum_fare_check" do
    it "raise an error if balance is less than 1" do
      expect { subject.minimum_fare_check }.to raise_error "Not enough funds, minimum balance required 1"
    end
  end

  describe "#store_journey" do
    it "stores the journey after touch_out" do
      subject.top_up(20)
      subject.touch_in(euston)
      subject.touch_out(kingscross)
      expect(subject.journeys).to eq([{ entrystation: 'euston', entrystationzone: 1, exitstation: 'kingscross', exitstationzone: 2 }])
    end
  end
end
