require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  before :each do 
    @user = FactoryGirl.create(:user)
  end
  after :each do
    session.delete(:user_id)
    @current_user = nil
    cookies.delete :user_id
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

  describe "#remembered_user!" do
    it "blows up if cookie isn't set" do
      expect{remembered_user!}.to raise_error(ActiveRecord::RecordNotFound)
    end
    it "returns user if cookie is set" do
      remember(@user)
      expect(remembered_user!).to eq(@user)
    end
  end

  describe "#remember(user)" do
    it "sets user id in a cookie" do
      remember(@user)
      expect(cookies.signed[:user_id]).to eq(@user.id)
    end
  end

  describe "#remembered?" do
    it "returns true if cookie is set" do
      remember(@user)
      expect(remembered?).to be_truthy
    end
    it "returns false if cookie isn't set" do
      expect(remembered?).to be_falsey
    end
  end
end 