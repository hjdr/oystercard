require 'journeys'

describe Journey do

  let(:euston) { double 'station', name: 'euston', zone: 1 }
  let(:kingscross) { double 'station', name: 'kings_cross', zone: 2 }

  describe "#start" do
    it "starts the journey" do
      expect(subject.start(euston)).to eq euston
    end
  end

  describe "#end" do
    it "ends the journey" do
      subject.start(euston)
      expect(subject.end(kingscross)).to eq kingscross
    end
  end


  describe "#complete?" do
    context "when the journey has ended" do
      it "confirms journey has ended" do
        subject.start(euston)
        subject.end(kingscross)
        expect(subject.complete?).to eq(true)
      end
    end

    context "when the journey in progress" do
      it "confirms the journey is not complete" do
        subject.start(euston)
        expect(subject.complete?).to eq(false)
      end
    end
  end

  describe "#fare" do
    context "when previous journey is complete" do
      it "it returns minimum fare" do
        subject.start(euston)
        subject.end(kingscross)
        expect(subject.fare).to eq 1
      end
    end

    context "when previous exit station is nil" do
      it "it returns penalty fare" do
        subject.start(euston)
        expect(subject.fare).to eq 6
      end
    end

    context "when previous entry station is nil" do
      it "it returns penalty fare" do
        subject.end(kingscross)
        expect(subject.fare).to eq 6
      end
    end

    describe "#entry_check_fine?" do
      it "checks whether the exit station is assigned & entry station is nil" do
        subject.start(euston)
        subject.end(kingscross)
        expect(subject.entry_check_fine?).to eq(false)
      end
    end

    it "checks whether the exit station is assigned & entry station is nil" do
      subject.start(euston)
      expect(subject.entry_check_fine?).to eq(true)
    end

  end
end