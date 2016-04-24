require 'shellwords'

class GrantsGovScraper < BaseScraper
  DOWNLOAD_URL_TEMPLATE = 'http://www.grants.gov/web/grants/xml-extract.html?p_p_id=xmlextract_WAR_grantsxmlextractportlet_INSTANCE_5NxW0PeTnSUa&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_cacheability=cacheLevelPage&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&download=FILENAME'

  def run
    xml = grant_xml

    xml.xpath('//FundingOppSynopsis').each do |funding_opp|
      description = funding_opp.xpath('./FundingOppDescription').text
      foreign_key = funding_opp.xpath('./CFDANumber').text
      office = funding_opp.xpath('./Office').text
      agency = funding_opp.xpath('./Agency').text
      name = funding_opp.xpath('./FundingOppTitle').text
      number_of_recipients = funding_opp.xpath('./NumberOfAwards').text
      min_amount = funding_opp.xpath('./AwardFloor').text
      max_amount = funding_opp.xpath('./AwardCeiling').text
      total_amount = funding_opp.xpath('./EstimatedFunding').text

      funder = Funder.find_or_create_by!(name: "#{office}, #{agency}")

      existing_opportunity = Opportunity.find_by(first_source: grants_gov_source, foreign_key: foreign_key) || Opportunity.create!(name: name, funder: funder, first_source: grants_gov_source, foreign_key: foreign_key)
      existing_opportunity.update_attributes description: description,
                                             name: name,
                                             number_of_recipients: number_of_recipients,
                                             min_amount: min_amount,
                                             max_amount: max_amount,
                                             total_amount: total_amount

    end
  end

  def grants_gov_source
    @source ||= Source.find_or_create_by!(name: 'Grants.gov', url: 'http://www.grants.gov/')
  end

  def grant_xml
    file = Tempfile.new(['grants', '.zip'])
    tmp_directory = File.dirname(file)

    system "curl -s #{Shellwords.escape download_url} > #{Shellwords.escape file.path}"
    system "unzip -u #{Shellwords.escape file.path} -d #{Shellwords.escape tmp_directory}"
    puts "Zipfile in #{tmp_directory}, named #{xml_file_name}"
    Nokogiri::XML(File.read(File.join(tmp_directory, xml_file_name)))
  ensure
    file.unlink if file
  end

  def download_url
    DOWNLOAD_URL_TEMPLATE.gsub(/FILENAME/, zip_file_name)
  end

  def zip_file_name
    'GrantsDBExtractTIMESTAMP.zip'.gsub(/TIMESTAMP/, 1.day.ago.strftime('%Y%m%d'))
  end

  def xml_file_name
    'GrantsDBExtractTIMESTAMP.xml'.gsub(/TIMESTAMP/, 1.day.ago.strftime('%Y%m%d'))
  end
end
