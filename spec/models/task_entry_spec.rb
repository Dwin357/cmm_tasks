require 'rails_helper'

RSpec.describe TaskEntry, type: :model do
  let(:subject) {FactoryGirl.build(:alt_task_entry)}
  let(:before_active_window) do
    subject.start_time = 1.hour.from_now.utc
    subject.end_time = 2.hours.from_now.utc
    subject
  end
  let(:after_active_window) do
    subject.start_time = 2.hours.ago.utc
    subject.end_time = 1.hour.ago.utc
    subject
  end
  let(:inside_active_window) do
    subject.start_time = 1.hour.ago.utc
    subject.end_time = 1.hour.from_now.utc
    subject
  end

  describe "assumptions" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:task_entry)).to be_valid
    end
    it "has a valid alt_factory" do
      expect(FactoryGirl.create(:alt_task_entry)).to be_valid
    end
    it 'factory :alt_task_entry start time' do
      expect(FactoryGirl.build(:alt_task_entry).start_time).to eq(Time.new(2000, 1, 1, 1, 5).utc)
    end

    # it 'factory end time' do
    #   expect(FactoryGirl.build(:alt_task_entry).end_time).to eq(Time.new(2000, 1, 1, 13, 13).utc)
    # end
  end
  describe "associations" do
    it "belongs to tasks" do
      subject = TaskEntry.reflect_on_association(:task)
      expect(subject.macro).to eq(:belongs_to)
    end
  end
  describe "duck attribute" do
    describe "root db attributes backstoped by default values" do
      it '#start_time' do
        expect(TaskEntry.new.start_time).not_to be nil
      end
      it '#duration' do
        expect(TaskEntry.new.duration).not_to be nil
      end
    end
    describe 'end_time' do
      it '#end_time adds duration to start_time' do
        s_time = subject.start_time
        dur = subject.duration
        expect(subject.end_time).to eq(s_time+dur)
      end
      it '#end_time=() adjusts duration' do
        s_time = subject.start_time
        subject.end_time = (s_time + 600)
        expect(subject.duration).to eq(600)
      end
      it 'is in utc format' do
        expect(subject.end_time.utc?).to be true
      end
    end
    # describe 's_time' do
    #   it '#s_time returns "HH:mm"' do
    #     expect(subject.s_time).to eq("01:05")
    #   end
    #   it '#s_time=() updates start time' do
    #     comparison = 
    #       subject.start_time.clone.getlocal.change({hour:2,min:50}).utc
    #     subject.s_time = "02:50"
    #     expect(subject.start_time).to eq(comparison)
    #   end
    # end
    # describe 's_date' do
    #   it '#s_date returns "yyyy-mm-dd"' do
    #     expect(subject.s_date).to eq("2000-01-01")
    #   end
    #   it '#s_date=() updates start time' do
    #     comparison = 
    #       subject.start_time.clone.getlocal.change({year:2015,month:5,day:12}).utc
    #     subject.s_date = "2015-05-12"
    #     expect(subject.start_time).to eq(comparison)
    #   end
    # end
    # describe 'e_time' do
    #   it '#e_time returns "HH:mm"' do
    #     expect(subject.e_time).to eq("06:13")
    #   end
    #   it '#e_time=() updates start time' do
    #     comparison = 
    #       subject.end_time.clone.getlocal.change({hour:2,min:50}).utc
    #     subject.e_time = "02:50"
    #     expect(subject.end_time).to eq(comparison)
    #   end
    # end
    # describe 'e_date' do
    #   it '#e_date returns "yyyy-mm-dd"' do
    #     expect(subject.e_date).to eq("2006-11-23")
    #   end
    #   it '#e_date=() updates start time' do
    #     comparison = 
    #       subject.end_time.clone.getlocal.change({year:2015,month:5,day:12}).utc
    #     subject.e_date = "2015-05-12"
    #     expect(subject.end_time).to eq(comparison)
    #   end
    # end
  end
  describe "booleans" do
    describe "#active?" do
      describe "returns true" do
        it "inside the active window" do
          expect(inside_active_window.active?).to be true
        end
      end
      describe "returns false" do
        it "before active window" do        
          expect(before_active_window.active?).to be false
        end
        it "after active window" do        
          expect(after_active_window.active?).to be false
        end
      end
    end
    describe "#pending?" do
      describe "returns true" do
        it "before active window" do        
          expect(before_active_window.pending?).to be true
        end
      end
      describe "returns false" do
        it "inside the active window" do
          expect(inside_active_window.pending?).to be false
        end
        it "after active window" do        
          expect(after_active_window.pending?).to be false
        end
      end
    end
    describe "#completed?" do
      describe "returns true" do
        it "after active window" do        
          expect(after_active_window.completed?).to be true
        end
      end
      describe "returns false" do
        it "before active window" do        
          expect(before_active_window.completed?).to be false
        end
        it "inside the active window" do
          expect(inside_active_window.completed?).to be false
        end
      end
    end
  end
end
