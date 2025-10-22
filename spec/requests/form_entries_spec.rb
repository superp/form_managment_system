require 'rails_helper'

RSpec.describe 'Form Entries API', type: :request do
  let(:user) { create(:user) }
  let(:form) { create(:form, user: user) }
  let(:string_field) { create(:field, :string) }
  let(:integer_field) { create(:field, :integer) }
  let(:datetime_field) { create(:field, :datetime) }
  let!(:form_field1) { create(:form_field, form: form, field: string_field, position: 1) }
  let!(:form_field2) { create(:form_field, form: form, field: integer_field, position: 2) }
  let!(:form_field3) { create(:form_field, form: form, field: datetime_field, position: 3) }

  before :each do
    start_new_session_for user
  end

  describe 'GET /forms/:form_id/form_entries' do
    it 'returns a successful response' do
      get form_entries_path(form)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /forms/:form_id/form_entries/new' do
    it 'returns a successful response' do
      get new_form_entry_path(form)
      expect(response).to have_http_status(:success)
    end

    it 'pre-builds entry values for each form field' do
      get new_form_entry_path(form)
      expect(response.body).to include(string_field.name)
      expect(response.body).to include(integer_field.name)
      expect(response.body).to include(datetime_field.name)
    end
  end

  describe 'POST /forms/:form_id/form_entries' do
    let(:valid_entry_values) do
      {
        form_field1.id.to_s => 'Test String Value',
        form_field2.id.to_s => '42',
        form_field3.id.to_s => '2024-01-01T12:00:00'
      }
    end

    context 'with valid parameters' do
      it 'creates a new form entry' do
        expect {
          post form_entries_path(form), params: { entry_values: valid_entry_values }
        }.to change(FormEntry, :count).by(1)
      end

      it 'creates entry values for each field' do
        expect {
          post form_entries_path(form), params: { entry_values: valid_entry_values }
        }.to change(EntryValue, :count).by(3)
      end

      it 'redirects to the form' do
        post form_entries_path(form), params: { entry_values: valid_entry_values }
        expect(response).to redirect_to(form_path(form))
      end

      it 'sets correct values for different field types' do
        post form_entries_path(form), params: { entry_values: valid_entry_values }

        form_entry = FormEntry.last
        string_entry_value = form_entry.entry_values.find_by(form_field: form_field1)
        integer_entry_value = form_entry.entry_values.find_by(form_field: form_field2)
        datetime_entry_value = form_entry.entry_values.find_by(form_field: form_field3)

        expect(string_entry_value.string_value).to eq('Test String Value')
        expect(integer_entry_value.integer_value).to eq(42)
        expect(datetime_entry_value.datetime_value).to be_present
      end
    end
  end

  describe 'GET /forms/:form_id/form_entries/:id' do
    let(:form_entry) { create(:form_entry, form: form) }

    it 'returns a successful response' do
      get form_entry_path(form, form_entry)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /forms/:form_id/form_entries/:id/edit' do
    let(:form_entry) { create(:form_entry, form: form) }

    it 'returns a successful response' do
      get edit_form_entry_path(form, form_entry)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /forms/:form_id/form_entries/:id' do
    let(:form_entry) { create(:form_entry, form: form) }
    let(:updated_entry_values) do
      {
        form_field1.id.to_s => 'Updated String Value',
        form_field2.id.to_s => '100',
        form_field3.id.to_s => '2024-12-31T23:59:59'
      }
    end

    context 'with valid parameters' do
      it 'updates the form entry' do
        patch form_entry_path(form, form_entry), params: { entry_values: updated_entry_values }

        form_entry.reload
        string_entry_value = form_entry.entry_values.find_by(form_field: form_field1)
        integer_entry_value = form_entry.entry_values.find_by(form_field: form_field2)
        datetime_entry_value = form_entry.entry_values.find_by(form_field: form_field3)

        expect(string_entry_value.string_value).to eq('Updated String Value')
        expect(integer_entry_value.integer_value).to eq(100)
        expect(datetime_entry_value.datetime_value).to be_present
      end

      it 'redirects to the form' do
        patch form_entry_path(form, form_entry), params: { entry_values: updated_entry_values }
        expect(response).to redirect_to(form_path(form))
      end
    end
  end

  describe 'DELETE /forms/:form_id/form_entries/:id' do
    let!(:form_entry) { create(:form_entry, form: form) }

    it 'destroys the form entry' do
      expect {
        delete form_entry_path(form, form_entry)
      }.to change(FormEntry, :count).by(-1)
    end

    it 'redirects to the form' do
      delete form_entry_path(form, form_entry)
      expect(response).to redirect_to(form_path(form))
    end
  end
end
