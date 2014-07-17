require 'spec_helper'

describe ApplicationHelper, :type => :helper do

  describe "full_title" do
    it "should include the page title" do
      expect(full_title("foo")).to match(/foo/)
    end

    it "should include the base title" do
      base_title = I18n.t(:base_title)
      expect(full_title("foo")).to match(/^#{base_title}/)
    end

    it "should not include a bar for the home page" do
      expect(full_title("")).not_to match(/\|/)
    end
  end
end
