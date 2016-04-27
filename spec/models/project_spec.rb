require 'rails_helper'

RSpec.describe Project, type: :model do  
  describe "associations" do
    it "belongs to customer" do
      subject = Project.reflect_on_association(:customer)
      expect(subject.macro).to eq(:belongs_to)
    end
    it "has many tasks" do
      subject = Project.reflect_on_association(:tasks)
      expect(subject.macro).to eq(:has_many)
    end
  end
end
