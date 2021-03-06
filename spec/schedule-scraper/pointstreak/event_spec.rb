require File.expand_path(File.join(File.dirname(__FILE__), '../../spec_helper'))

describe ScheduleScraper::Pointstreak::Event do
  let(:options) { POINTSTREAK_OPTIONS }
  let(:fields) { [:home_team, :away_team, :date, :time, :rink] }
  let(:expected_values) do
    {
      :home_team => "BLADES 6",
      :away_team => "SUMMIT 8",
      :date => "Sun, Jun 03",
      :time => "7:45 pm",
      :rink => "final"
    }
  end

  before do
    VCR.use_cassette('summit_summer_2012') do
      @schedule = ScheduleScraper::Pointstreak::Schedule.fetch(options)
    end
  end

  subject() { @schedule.events.first }

  [:home_team, :away_team, :date, :time, :rink].each do |field|
    it "can find the #{field.to_s.gsub('_', ' ')}" do
      subject.send(field).wont_be_nil
    end
  end

  it "uses elements to define fields for csv" do
    klass = ScheduleScraper::Pointstreak::Event
    klass.send(:export_fields).must_equal expected_values.keys
  end

  it "returns a list of fields when you ask for csv" do
    subject.to_csv.must_equal expected_values.values
  end
end
