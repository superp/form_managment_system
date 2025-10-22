class UpdateFormService
  def initialize(form, form_params)
    @form = form
    @form_params = form_params
  end

  def call
    @form.assign_attributes(@form_params)
    @form
  end
end
