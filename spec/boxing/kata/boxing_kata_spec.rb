require "spec_helper"

RSpec.describe Boxing::Kata do
  it "has a version number" do
    expect(Boxing::Kata::VERSION).not_to be nil
  end

  describe '#read_csv_file' do
    it "returns error if invalid file" do
      response = Boxing::Kata.read_csv_file('')
      expect(response).to eq(nil)
    end

    it "returns data if valid file" do
      response = Boxing::Kata.read_csv_file('spec/fixtures/family_preferences.csv')
      expect(response).not_to be_nil
    end
  end
end
