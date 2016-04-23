require 'rails_helper'

RSpec.describe GrantsGovScraper do
  let(:scraper) { GrantsGovScraper.new }

  describe '#run' do
    before do
      allow(scraper).to receive(:grant_xml).and_return(Nokogiri::XML(File.read(Rails.root.join('spec', 'file_fixtures', 'grants_gov', 'example.xml'))))
    end

    it 'fetches an updated XML file' do
      scraper.run
      expect(scraper).to have_received(:grant_xml)
    end

    context 'with new opportunities' do
      it 'creates them' do
        expect {
          scraper.run
        }.to change { Opportunity.count }.by(2)

        expect(Opportunity.last.name).to eq('NATIONAL PARK SERVICE RECOVERY ACT Whiskeytown National Recreation Area, Repair and Maintain Parkwide Trails')
        expect(Opportunity.last.foreign_key).to eq('15.931')
        expect(Opportunity.last.first_source).to eq(scraper.grants_gov_source)
      end

      it 'creates a funder' do
        expect {
          scraper.run
        }.to change { Funder.count }.by(2)

        expect(Opportunity.last.funder.name).to eq('National Park Service, Department of the Interior')
      end
    end

    context 'with existing opportunities' do
      it 'does not create duplicate opportunities' do
        expect {
          scraper.run
        }.to change { Funder.count }.by(2)

        expect {
          scraper.run
        }.to change { Funder.count }.by(0)
      end

      it 'updates existing entries' do
        expect {
          scraper.run
        }.to change { Funder.count }.by(2)

        Opportunity.last.update_attribute :name, 'A different name'

        expect {
          scraper.run
        }.to change { Funder.count }.by(0)

        expect(Opportunity.last.name).to eq('NATIONAL PARK SERVICE RECOVERY ACT Whiskeytown National Recreation Area, Repair and Maintain Parkwide Trails')
      end
    end
  end
end

describe '#download_url' do
  it "returns a download URL with yesterday's date" do
    expect(GrantsGovScraper.new.download_url).to match(/GrantsDBExtract#{1.day.ago.strftime('%Y%m%d')}.zip/)
  end
end
