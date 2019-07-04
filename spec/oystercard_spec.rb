require 'oystercard'

describe Oystercard do

  let(:euston) { double 'station', name: 'euston', zone: 1 }
  let(:kingscross) { double 'station', name: 'kingscross', zone: 2 }
  let(:journey) { double 'journey', start: 'euston', end: 'kingscross' }

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
      it "passes the station to journey object" do
        subject.top_up(20)
        expect(journey).to receive(:start)
        subject.touch_in(euston, journey)
      end 
    end

    context "with insufficient funds" do
      it "raises an error message" do
        expect { subject.touch_in(euston, journey) }.to raise_error "Not enough funds, minimum balance required 1"
      end
    end

    # it "charges fee if last journey was incomplete" do


  end

  describe "#touch_out" do

    before :each do
      subject.top_up(20)
      subject.touch_in(euston, journey)
    end

    it "charges the minimum balance" do
      allow(journey).to receive(:fare) { 1 }
      expect {subject.touch_out(kingscross)}.to change{subject.balance}.by(-1)
    end

    it "charges the penalty balance" do
      allow(journey).to receive(:fare) { 6 }
      expect {subject.touch_out(kingscross)}.to change{subject.balance}.by(-6)
    end
  end
end
