require 'spec_helper'

describe AccountsController, :type => :controller do

  let(:admin)  { create(:admin) }
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
      expect(response).to redirect_to client
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
      expect(response).to redirect_to client
    end
  end

  describe "PDF generation" do
    let(:operation) do
      create(:deposit,
             close_date: Date.today + 6.months,
             sum: 1000,
             rate: 12,
             withholding: 12)
      end

    it "returns a PDF file inline" do
      get :report, id: operation.account, format: :pdf
      expect(response.headers['Content-Type']).to have_content 'pdf'
      expect(response.content_type).to eq("application/pdf")
    end
  end
end
