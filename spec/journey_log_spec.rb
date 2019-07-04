require 'journey_log'

describe JourneyLog do
  let(:journey) { double 'journey', start: 'euston', end: 'kingscross' }

  describe '#start' do
    it 'sends the start message to journey object' do
      expect(journey).to receive(:start)
      subject.start('', journey)
    end
  end

  describe '#finish' do
    it 'sends the end message to journey object' do
      expect(journey).to receive(:end)
      subject.start('', journey)
      subject.finish('')
    end
  end

  describe '#history' do
    it 'returns a list of previous journeys' do
      subject.start('', journey)
      subject.finish('')
      expect(subject.history).to include journey
    end
  end
end
