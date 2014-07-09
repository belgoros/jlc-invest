# We need to monkey patch ActiveRecord to use threads
=begin
  The short answer is it’s due to how Selenium handles database transactions.
  We need to share data state across the Selenium web server and the test code itself.
  Without DatabaseCleaner and the above patch, we’re apt to get sporadic error messages resulting from
  tests not properly cleaning up after themselves.

  For a more complete description of this setup, check out Avdi Grimm’s Virtuous Code blog:
  http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/

=end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
