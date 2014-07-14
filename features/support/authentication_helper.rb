module AuthenticationHelper

  def sign_in(user)
    #visit new_user_session_path
    visit signin_path
    fill_in I18n.t('activerecord.attributes.admin.email'), with: user.email
    fill_in I18n.t('activerecord.attributes.admin.password'), with: user.password
    click_button I18n.t('links.sign_in')
  end

  def current_user(attributes = {})
    @current_user ||= create(:user, attributes)
  end
end

World(AuthenticationHelper)
