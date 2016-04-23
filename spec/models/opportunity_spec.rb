require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  let(:valid_params) { { name: 'something', first_source_id: 1, funder_id: 2, foreign_key: 'something' } }
  let(:opportunity) { Opportunity.new(valid_params) }

  describe '#validations' do
    it 'enforces presence of name' do
      opportunity.name = ''
      expect(opportunity).not_to be_valid
      expect(opportunity).to have(1).errors_on(:name)
    end

    it 'enforces uniqueness of funder_id and foreign_key' do
      expect(opportunity).to be_valid
      opportunity.save!
      expect(Opportunity.new(valid_params)).to_not be_valid
    end
  end
end
