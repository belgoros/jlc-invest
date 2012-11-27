require 'spec_helper'

describe AccountsController do

  let(:admin) { create(:admin) }
  let(:client) { create(:client) }

  before(:each) { sign_in admin }

  describe "POST create" do
    it "creates a new account" do
      expect {
        post :create, account: {client_id: client.id}
      }.to change(Account, :count).by(1)
    end

    it "redirects to the client accounts page" do
      post :create, account: {client_id: client.id}
      response.should redirect_to client
    end
  end

  describe 'DELETE #destroy' do

    before(:each) do
      @account = create(:account, client: client)
    end

    it "deletes the account from the database" do
      expect {
        delete :destroy, id: @account
      }.to change(Account, :count).by(-1)
    end

    it "redirects to the clients accounts page" do
      delete :destroy, id: @account
      response.should redirect_to client
    end
  end

  describe "PDF generation" do
    before { @account = create(:account, client: client) }
    it "creates a PDF report for a specified account" do
      get :report, id: @account,  format: :pdf
      response.content_type.should eq("application/pdf")
      response.headers["Content-Disposition"].should eq("inline")      
    end
  end

end