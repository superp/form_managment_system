require 'rails_helper'

RSpec.describe 'Fields API', type: :request do
  let(:user) { create(:user) }
  let(:field) { create(:field, :string, user: user) }
  let(:valid_attributes) do
    {
      name: 'Test Field',
      field_type: 'string',
      min_length: 1,
      max_length: 100
    }
  end

  before :each do
    start_new_session_for user
  end

  describe 'GET /fields' do
    it 'returns a successful response' do
      get fields_path
      expect(response).to have_http_status(:success)
    end

    it 'displays form fields' do
      field = create(:field, :string, user: user)
      get fields_path
      expect(response.body).to include(field.name)
    end
  end

  describe 'GET /fields/new' do
    it 'returns a successful response' do
      get new_field_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /fields' do
    context 'with valid parameters' do
      it 'creates a new field' do
        expect {
          post fields_path, params: { field: valid_attributes }
        }.to change(Field, :count).by(1)
      end

      it 'redirects to the field' do
        post fields_path, params: { field: valid_attributes }
        expect(response).to redirect_to(field_path(Field.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new field' do
        expect {
          post fields_path, params: { field: { name: '' } }
        }.not_to change(Field, :count)
      end

      it 'renders the new template' do
        post fields_path, params: { field: { name: '' } }
        expect(response).to render_template(:new)
      end
    end
  end
end
