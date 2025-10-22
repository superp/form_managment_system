class FormEntriesController < ApplicationController
  before_action :find_form
  before_action :find_form_entry, only: [ :show, :edit, :update, :destroy ]
  before_action :find_form_fields, only: [ :new, :create, :edit, :update ]
  before_action :build_form_entry, only: [ :new, :create ]

  def authorize_resource
    authorize! :manage, @form if @form
    authorize! :manage, @form_entry if @form_entry
  end

  def index
    @form_entries = @form.form_entries.ordered
  end

  def show; end

  def new
    # Pre-build entry values for each form field
    @form_fields.each do |form_field|
      @form_entry.entry_values.build(form_field: form_field)
    end
  end

  def create
    @form_entry = ::CreateEntryService.new(@form, params[:entry_values]).call

    if @form_entry.save
      redirect_to form_path(@form), notice: "Form entry was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    ::UpdateEntryService.new(@form_entry, params[:entry_values]).call

    if @form_entry.save
      redirect_to form_path(@form), notice: "Form entry was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @form_entry.destroy
    redirect_to form_path(@form), notice: "Form entry was successfully destroyed."
  end

  private

  def find_form
    @form = current_user.forms.find(params[:form_id])
  end

  def find_form_entry
    @form_entry = @form.form_entries.find(params[:id])
  end

  def find_form_fields
    @form_fields = @form.form_fields.includes(:field).ordered
  end

  def build_form_entry
    @form_entry = @form.form_entries.build
  end
end
