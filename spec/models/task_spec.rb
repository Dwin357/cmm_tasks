require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "associations" do
    it "belongs to project" do
      subject = Task.reflect_on_association(:project)
      expect(subject.macro).to eq(:belongs_to)
    end
    it "belongs to user" do
      subject = Task.reflect_on_association(:user)
      expect(subject.macro).to eq(:belongs_to)
    end
    it "has many task_entries" do
      subject = Task.reflect_on_association(:task_entries)
      expect(subject.macro).to eq(:has_many)
    end
  end
end
