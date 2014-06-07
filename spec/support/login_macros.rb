module LoginMacros
  def sign_in_with_browser(user)
    visit signin_path
    fill_in I18n.t('activerecord.attributes.admin.email'), with: user.email
    fill_in I18n.t('activerecord.attributes.admin.password'), with: user.password
    click_button I18n.t('links.sign_in')
  end

  def sign_out_with_browser
    click_link I18n.t('links.sign_out')
  end
end
