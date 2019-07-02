require 'station'

describe Station do
  it "Name Station?" do
    station = Station.new('euston', 1)
    expect(station.name).to eq('euston')
  end
  it "zone Station?" do
    station = Station.new('euston', 1)
    expect(station.zone).to eq(1)
  end
end
