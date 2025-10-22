class CsvExportService
  def initialize(form, form_fields, form_entries)
    @form = form
    @form_fields = form_fields
    @form_entries = form_entries
  end

  def call
    require 'csv'
    presenter = FormResultsPresenter.new(@form, @form_fields, @form_entries)

    CSV.generate do |csv|
      presenter.csv_data.each { |row| csv << row }
    end
  end
end
