require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  before :each do
    @user = FactoryGirl.create(:user)
  end
  after :each do
    session.delete(:user_id)
    @current_user = nil
  end


  describe "#login(user)" do
    it "sets user id to session" do
      login(@user)
      expect(session[:user_id]).to eq(@user.id)
    end
  end

  describe "#logout" do
    it "clears user_id from session" do
      login(@user)
      logout
      expect(session[:user_id]).to be(nil)
    end
    it "clears @current_user cache" do
      login(@user)
      current_user
      logout
      expect(@current_user).to be(nil)
    end
  end

  describe "#current_user" do
    it "returns nil if session is not set" do
      expect(current_user).to be(nil)
    end
    it "returns the user if session is set" do
      login(@user)
      expect(current_user).to eq(@user)
    end
    it "caches the user in @current_user" do
      login(@user)
      current_user
      expect(@current_user).to eq(@user)
    end
  end

  describe "#current_user!" do
    it "blows up if session isn't set" do
      expect{ current_user! }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it "returns the user if session is set" do
      login(@user)
      expect(current_user!).to eq(@user)
    end
    it "caches the user in @current_user" do
      login(@user)
      current_user!
      expect(@current_user).to eq(@user)
    end
  end  
end 