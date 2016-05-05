require 'rails_helper'

RSpec.describe TaskEntry, type: :model do
  let(:subject) {FactoryGirl.build(:task_entry)}
  let(:after_active_window) do
    subject
    subject.start_time = 5.minutes.ago
    subject.duration = 180 #seconds
    subject
  end
  let(:before_active_window) do
    subject
    subject.start_time = 5.minutes.from_now
    subject.duration = 180 #seconds
    subject
  end
  let(:inside_active_window) do
    subject
    subject.start_time = 1.minutes.ago
    subject.duration = 180 #seconds
    subject
  end

  describe "assumptions" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:task_entry)).to be_valid
    end
    it "has a valid alt_factory" do
      expect(FactoryGirl.create(:alt_task_entry)).to be_valid
    end
  end
  describe "associations" do
    it "belongs to tasks" do
      subject = TaskEntry.reflect_on_association(:task)
      expect(subject.macro).to eq(:belongs_to)
    end
  end
  describe "duck attribute" do
    it "#end_time" do
      time = Time.now
      subject.start_time = time
      subject.duration = 500
      expect(subject.end_time).to eq(time+500)
    end
    it '#end_time=()' do
      time = Time.now
      subject.start_time = time
      subject.end_time = (time + 500)
      expect(subject.start_time).to eq(time)
      expect(subject.end_time).to eq(time+500)
      expect(subject.duration).to eq(500)
    end
    # it '#start_at' do
    #   subject.start_time = Time.new(2016, 1, 23, 1, 15)
    #   subject.end_time = Time.new(2016, 11, 2, 13, 5)
    #   expect(subject.start_at).to eq("01:15")
    # end
    # it '#end_at' do
    #   subject.start_time = Time.new(2016, 1, 23, 1, 15)
    #   subject.end_time = Time.new(2016, 11, 2, 13, 5)
    #   expect(subject.end_at).to eq("13:05")
    # end
    it '#end_date' do
      subject.start_time = Time.new(2016, 1, 23, 1, 15)
      subject.end_time = Time.new(2016, 11, 2, 13, 5)
      expect(subject.end_date).to eq("2016-11-02")
    end
    it '#start_date' do
      subject.start_time = Time.new(2016, 1, 23, 1, 15)
      subject.end_time = Time.new(2016, 11, 2, 13, 5)
      expect(subject.start_date).to eq("2016-01-23")      
    end
  end
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
  describe "#logged?" do
    describe "returns true" do
      it "after active window" do        
        expect(after_active_window.logged?).to be true
      end
    end
    describe "returns false" do
      it "before active window" do        
        expect(before_active_window.logged?).to be false
      end
      it "inside the active window" do
        expect(inside_active_window.logged?).to be false
      end
    end
  end
end
