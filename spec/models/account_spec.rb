require 'spec_helper'

describe Account do
  let(:client) { create(:client) }
  subject { build(:account, client: client) }

  it { should be_valid}
end
