class FieldsController < ApplicationController
  load_and_authorize_resource
  before_action :set_field, only: [ :show, :edit, :update, :destroy ]

  def index
    @fields = current_user.fields.ordered
  end

  def show; end

  def new
    @field = current_user.fields.build
  end

  def create
    @field = current_user.fields.build(field_params)

    if @field.save
      redirect_to @field, notice: "Field was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @field.update(field_params)
      redirect_to @field, notice: "Field was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @field.destroy
    redirect_to fields_url, notice: "Field was successfully destroyed."
  end

  private

  def set_field
    @field = current_user.fields.find(params[:id])
  end

  def field_params
    params.require(:field).permit(:name, :field_type, :min_length, :max_length, :min_value, :max_value)
  end
end
