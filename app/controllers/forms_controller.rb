require_relative '../services/create_form_service'
require_relative '../services/update_form_service'
require_relative '../services/csv_export_service'

class FormsController < ApplicationController
  load_and_authorize_resource
  before_action :find_form, only: [:show, :edit, :update, :destroy, :results]

  def index
    @forms = current_user.forms.ordered
  end

  def show
    @form_fields = @form.form_fields.includes(:field).ordered
    @form_entries = @form.form_entries.ordered
  end

  def new
    @form = current_user.forms.build
    @available_fields = current_user.fields.ordered
  end

  def create
    @form = ::CreateFormService.new(current_user, form_params).call
    @available_fields = current_user.fields.ordered

    if @form.save
      redirect_to @form, notice: 'Form was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @available_fields = current_user.fields.ordered
  end

  def update
    ::UpdateFormService.new(@form, form_params).call

    if @form.save
      redirect_to @form, notice: 'Form was successfully updated.'
    else
      @available_fields = current_user.fields.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @form.destroy
    redirect_to forms_url, notice: 'Form was successfully destroyed.'
  end

  def results
    @form_fields = @form.form_fields.includes(:field).ordered
    @form_entries = @form.form_entries.ordered.includes(:entry_values)
    @results_presenter = FormResultsPresenter.new(@form, @form_fields, @form_entries)

    respond_to do |format|
      format.html
      format.csv do
        send_data generate_csv, filename: "form_#{@form.id}_results.csv"
      end
    end
  end

  private

  def find_form
    @form = current_user.forms.find(params[:id])
  end

  def form_params
    params.require(:form).permit(:title, :description,
                                 form_fields_attributes: [:id, :field_id, :position, :_destroy])
  end

  def generate_csv
    ::CsvExportService.new(@form, @form_fields, @form_entries).call
  end
end
