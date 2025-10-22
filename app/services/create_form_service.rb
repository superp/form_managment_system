class CreateFormService
  def initialize(user, form_params)
    @user = user
    @form_params = form_params
  end

  def call
    @user.forms.build(@form_params)
  end
end
