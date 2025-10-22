require 'rails_helper'

RSpec.describe UpdateEntryService do
  let(:user) { create(:user) }
  let(:form) { create(:form, user: user) }
  let(:form_entry) { create(:form_entry, form: form) }
  let(:string_field) { create(:field, :string) }
  let(:integer_field) { create(:field, :integer) }
  let(:datetime_field) { create(:field, :datetime) }
  let!(:form_field1) { create(:form_field, form: form, field: string_field, position: 1) }
  let!(:form_field2) { create(:form_field, form: form, field: integer_field, position: 2) }
  let!(:form_field3) { create(:form_field, form: form, field: datetime_field, position: 3) }

  describe '#call' do
    context 'with valid entry values' do
      let(:entry_values_params) do
        {
          form_field1.id.to_s => 'Updated String Value',
          form_field2.id.to_s => '100',
          form_field3.id.to_s => '2024-12-31T23:59:59'
        }
      end

      it 'updates existing entry values' do
        # Create existing entry values
        create(:entry_value, :string, form_entry: form_entry, form_field: form_field1, string_value: 'Old String')
        create(:entry_value, :integer, form_entry: form_entry, form_field: form_field2, integer_value: 50)

        service = described_class.new(form_entry, entry_values_params)
        updated_form_entry = service.call

        string_entry_value = updated_form_entry.entry_values.find_by(form_field: form_field1)
        integer_entry_value = updated_form_entry.entry_values.find_by(form_field: form_field2)

        expect(string_entry_value.string_value).to eq('Updated String Value')
        expect(integer_entry_value.integer_value).to eq(100)
      end

      it 'creates new entry values for fields without existing values' do
        service = described_class.new(form_entry, entry_values_params)
        updated_form_entry = service.call

        datetime_entry_value = updated_form_entry.entry_values.find_by(form_field: form_field3)
        expect(datetime_entry_value).to be_persisted
        expect(datetime_entry_value.datetime_value).to be_present
      end

      it 'uses the value= method for setting values' do
        service = described_class.new(form_entry, entry_values_params)
        updated_form_entry = service.call

        string_entry_value = updated_form_entry.entry_values.find_by(form_field: form_field1)
        expect(string_entry_value.value).to eq('Updated String Value')
      end

      it 'saves all entry values' do
        service = described_class.new(form_entry, entry_values_params)
        updated_form_entry = service.call

        expect(updated_form_entry.entry_values.all?(&:persisted?)).to be true
      end
    end

    context 'with empty entry values' do
      let(:entry_values_params) { {} }

      it 'does not create or update any entry values' do
        service = described_class.new(form_entry, entry_values_params)
        updated_form_entry = service.call

        expect(updated_form_entry.entry_values.count).to eq(0)
      end
    end

    context 'with nil entry values' do
      let(:entry_values_params) { nil }

      it 'does not create or update any entry values' do
        service = described_class.new(form_entry, entry_values_params)
        updated_form_entry = service.call

        expect(updated_form_entry.entry_values.count).to eq(0)
      end
    end

    context 'with mixed existing and new entry values' do
      let(:entry_values_params) do
        {
          form_field1.id.to_s => 'Updated String',
          form_field2.id.to_s => '200',
          form_field3.id.to_s => '2024-06-15T15:30:00'
        }
      end

      before do
        # Create only one existing entry value
        create(:entry_value, :string, form_entry: form_entry, form_field: form_field1, string_value: 'Old String')
      end

      it 'updates existing entry values' do
        service = described_class.new(form_entry, entry_values_params)
        updated_form_entry = service.call

        string_entry_value = updated_form_entry.entry_values.find_by(form_field: form_field1)
        expect(string_entry_value.string_value).to eq('Updated String')
      end

      it 'creates new entry values for fields without existing values' do
        service = described_class.new(form_entry, entry_values_params)
        updated_form_entry = service.call

        integer_entry_value = updated_form_entry.entry_values.find_by(form_field: form_field2)
        datetime_entry_value = updated_form_entry.entry_values.find_by(form_field: form_field3)

        expect(integer_entry_value).to be_persisted
        expect(datetime_entry_value).to be_persisted
        expect(integer_entry_value.integer_value).to eq(200)
        expect(datetime_entry_value.datetime_value).to be_present
      end
    end

    context 'with find_or_initialize_by behavior' do
      let(:entry_values_params) do
        {
          form_field1.id.to_s => 'Test Value'
        }
      end

      it 'finds existing entry value' do
        existing_entry_value = create(:entry_value, :string, form_entry: form_entry, form_field: form_field1)

        service = described_class.new(form_entry, entry_values_params)
        updated_form_entry = service.call

        string_entry_value = updated_form_entry.entry_values.find_by(form_field: form_field1)
        expect(string_entry_value.id).to eq(existing_entry_value.id)
        expect(string_entry_value.string_value).to eq('Test Value')
      end

      it 'initializes new entry value when none exists' do
        service = described_class.new(form_entry, entry_values_params)
        updated_form_entry = service.call

        string_entry_value = updated_form_entry.entry_values.find_by(form_field: form_field1)
        expect(string_entry_value).to be_persisted
        expect(string_entry_value.string_value).to eq('Test Value')
      end
    end
  end
end
