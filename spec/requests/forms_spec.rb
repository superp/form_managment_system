require 'rails_helper'

RSpec.describe 'Forms API', type: :request do
  let(:user) { create(:user) }
  let(:form) { create(:form, user: user) }
  let(:valid_attributes) do
    {
      title: 'Test Form',
      description: 'Test Description'
    }
  end

  before :each do
    start_new_session_for user
  end

  describe 'GET /forms' do
    it 'returns a successful response' do
      get forms_path
      expect(response).to have_http_status(:success)
    end

    it 'displays user forms' do
      form = create(:form, user: user)
      get forms_path
      expect(response.body).to include(form.title)
    end
  end

  describe 'GET /forms/:id' do
    it 'returns a successful response' do
      get form_path(form)
      expect(response).to have_http_status(:success)
    end

    it 'displays form details' do
      get form_path(form)
      expect(response.body).to include(form.title)
    end
  end

  describe 'GET /forms/new' do
    it 'returns a successful response' do
      get new_form_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /forms' do
    context 'with valid parameters' do
      it 'creates a new form' do
        expect {
          post forms_path, params: { form: valid_attributes }
        }.to change(Form, :count).by(1)
      end

      it 'redirects to the created form' do
        post forms_path, params: { form: valid_attributes }
        expect(response).to redirect_to(form_path(Form.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new form' do
        expect {
          post forms_path, params: { form: { name: '' } }
        }.not_to change(Form, :count)
      end

      it 'renders the new template' do
        post forms_path, params: { form: { name: '' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET /forms/:id/edit' do
    it 'returns a successful response' do
      get edit_form_path(form)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /forms/:id' do
    let(:new_attributes) { { title: 'Updated Form Name' } }

    context 'with valid parameters' do
      it 'updates the form' do
        patch form_path(form), params: { form: new_attributes }
        form.reload
        expect(form.title).to eq('Updated Form Name')
      end

      it 'redirects to the form' do
        patch form_path(form), params: { form: new_attributes }
        expect(response).to redirect_to(form_path(form))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the form' do
        patch form_path(form), params: { form: { name: '' } }
        form.reload
        expect(form.title).not_to eq('')
      end

      it 'renders the edit template' do
        patch form_path(form), params: { form: { title: '' } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /forms/:id' do
    it 'destroys the form' do
      form_to_delete = create(:form, user: user)
      expect {
        delete form_path(form_to_delete)
      }.to change(Form, :count).by(-1)
    end

    it 'redirects to forms index' do
      delete form_path(form)
      expect(response).to redirect_to(forms_path)
    end
  end
end
