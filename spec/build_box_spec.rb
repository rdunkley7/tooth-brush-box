require "spec_helper"

RSpec.describe BuildBox do

  hashed_data = [
    { :id=>2, :name=>"Anakin", :brush_color=>"blue", :primary_insured_id=>nil, :contract_effective_date=>'2018-01-01'},
    {:id=>3, :name=>"Padme", :brush_color=>"pink", :primary_insured_id=>2, :contract_effective_date=>nil},
    {:id=>4, :name=>"Luke", :brush_color=>"blue", :primary_insured_id=>2, :contract_effective_date=>nil},
    {:id=>5, :name=>"Leia", :brush_color=>"green", :primary_insured_id=>2, :contract_effective_date=>nil},
    {:id=>6, :name=>"Ben", :brush_color=>"green", :primary_insured_id=>2, :contract_effective_date=>nil}
  ]

  hashed_data2 = [
    { :id=>2, :name=>"Anakin", :brush_color=>"blue", :primary_insured_id=>nil, :contract_effective_date=>'2018-01-01'},
    {:id=>3, :name=>"Luke", :brush_color=>"blue", :primary_insured_id=>2, :contract_effective_date=>nil},
    {:id=>4, :name=>"leia", :brush_color=>"blue", :primary_insured_id=>2, :contract_effective_date=>nil},
    {:id=>5, :name=>"Ben", :brush_color=>"blue", :primary_insured_id=>2, :contract_effective_date=>nil},
  ]

  describe 'Create BuildBox' do
    subject { BuildBox.new(hashed_data) }
    it "BuildBox is created" do
      colors = %w[blue pink blue green green]
      expect(subject).not_to be nil
      expect(subject.colors).to eq(colors)
    end

    describe '#countBrushColors' do
      it "should have 2 blue brushes, 2 green brushes, 1 pink brush" do
        subject.count_brush_colors
        expect(subject.blue_count).to eq(2)
        expect(subject.green_count).to eq(2)
        expect(subject.pink_count).to eq(1)
      end

      context 'hash2 data' do
        subject { BuildBox.new(hashed_data2) }
        it "should have 1 blue brushes" do
          subject.count_brush_colors
          expect(subject.blue_count).to eq(4)
          expect(subject.green_count).to eq(0)
          expect(subject.pink_count).to eq(0)
        end
      end
    end

    describe '#calculateMailClass' do
      context 'greater than 16 ounces' do
        subject { BuildBox.new(hashed_data ) }
        it "starter BuildBox should return Priority label" do
          mail_class = subject.calculateMailClass(4, 'starter')
          expect(mail_class).to eq('Priority')
        end

        it "refill BuildBox should return Priority label" do
          mail_class = subject.calculateMailClass(3, 'refill')
          expect(mail_class).to eq('Priority')
        end
      end

      context 'less than or equal to 16 ounces' do
        subject { BuildBox.new(hashed_data ) }
        it "refill BuildBox should return First label" do
          mail_class = subject.calculateMailClass(1, 'refill')
          expect(mail_class).to eq('First')
        end
      end
    end

    describe '#scheduleRefills' do
      context 'gets the next refill dates' do
        subject { BuildBox.new(hashed_data ) }
        it "returns refill dates list" do
          refills = [Date.parse('2018-04-01'), Date.parse('2018-06-30'), Date.parse('2018-09-28'), Date.parse('2018-12-27')]
          expect(subject.schedule_refills).to eq(refills)
        end
      end
    end
  end

  describe '#buildStarterBuildBox' do
    context 'no choices made' do
      subject { BuildBox.new({} ) }
      it "print error message" do
        expect { subject.build_starter_box }.to output("NO STARTER BOXES GENERATED\n").to_stdout
      end
    end
  end

  describe '#buildRefillBuildBox' do
    context 'no starter BuildBoxes made' do
      subject { BuildBox.new({} ) }
      it "print error message" do
        expect { subject.build_refill_box }.to output("PLEASE GENERATE STARTER BOXES FIRST\n").to_stdout
      end
    end
  end
end
