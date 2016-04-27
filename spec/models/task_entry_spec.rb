require 'rails_helper'

RSpec.describe TaskEntry, type: :model do
  describe "associations" do
    it "belongs to tasks" do
      subject = TaskEntry.reflect_on_association(:task)
      expect(subject.macro).to eq(:belongs_to)
    end
  end
end
