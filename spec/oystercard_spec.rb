require 'oystercard'

describe Oystercard do

  let(:trainstation) {double('trainstation')}

    describe "#balance" do
      it "Set balance to 0 on initialize" do
        expect(subject.balance).to eq 0
      end
    end

    describe "#top_up" do
      it "Add money to the balance" do
        subject.top_up(20)
        expect(subject.balance).to eq 20
      end
    end

    describe "#top_up" do
      it "raises an error if combined balance > 90.00" do
        card = Oystercard.new
        expect { card.top_up(95) }.to raise_error("amount exceeded, balance cannot be: 95. Balance limit is 90")
      end
    end

    describe "#touch_in" do
      context "with sufficient funds" do
        it "returns the in use status of the oystercard" do
          subject.top_up(20)
          expect(subject.touch_in(trainstation)).to eq true
        end
        it "Remember the entry station" do
          subject.top_up(20)
          trainstation =  double("trainstation")
          subject.touch_in(trainstation)
          expect(subject.entry_station).to eq (trainstation)
        end
      end
    end

      context "with insufficient funds" do
        it "returns the in use status of the oystercard" do
          expect { subject.touch_in(trainstation) }.to raise_error "Not enough funds, minimum balance required 1"
        end
      end

    describe "#touch_out" do
      it "returns not in use status of the oystercard" do
        expect(subject.touch_out).to eq false
      end
      it "charge the journey" do
        expect {subject.touch_out}.to change{subject.balance}.by(-1)
      end
    end

    describe "#in_journey?" do
      it "returns the oyestercard is in use" do
        subject.top_up(20)
        subject.touch_in(trainstation)
        expect(subject.in_journey?).to eq true
      end

      it "returns the oystercard is not in use" do
        subject.touch_out
        expect(subject.in_journey?).to eq false
      end
    end

    describe "#minimum_fare_check" do
      it "raise an error if balance is less than 1" do
        expect { subject.minimum_fare_check }.to raise_error "Not enough funds, minimum balance required 1"
      end
    end
end
