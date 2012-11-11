include ApplicationHelper
include ActionView::Helpers::NumberHelper

def sign_in(user)
  visit signin_path
  fill_in I18n.t('activerecord.attributes.admin.email'), with: user.email
  fill_in I18n.t('activerecord.attributes.admin.password'), with: user.password
  click_button I18n.t('links.sign_in')
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end
