require 'open-uri'

class NsfScraper < BaseScraper
  BASE_URL = 'http://api.nsf.gov/services/v1/awards.json?agency=AGENCY&offset=OFFSET'

  def awrun(agency: 'NSF')
    json = JSON.parse(open(url(agency: agency)).read)
    json['response']['award'].each do |award|
      # "agency" : "NASA",
      #   "awardeeCity" : "MORGANTOWN",
      #   "awardeeStateCode" : "WV",
      #   "fundsObligatedAmt" : "150001",
      #   "id" : "NNX16AG76G",
      #   "piFirstName" : "PAUL",
      #   "piLastName" : "CASSAK",
      #   "publicAccessMandate" : "0",
      #   "date" : "03/25/2016",
      #   "title" : "THE INTERACTION OF THE SOLAR WIND WITH EARTH S MAGNETOSPHERE IS CRUCIAL FOR PREDICTING SPACE WEATHER, WHICH CAN IMPACT SATELLITE COMMUNICATION AND THE POWER GRID, AMONG OTHER THINGS. THE COUPLING PROCESS OCCURS THROUGH MAGNETIC RECONNECTION AT THE DAYSIDE"
      # }, {

      location = "#{award['awardeeCity']}, #{award['awardeeStateCode']}"
      foreign_key = award['id']
      title = award['title']
      funder = Funder.find_or_create_by!(name: agency)


    end
  end

  def url(agency: 'nsf', offset: 0)
    BASE_URL.gsub('AGENCY', agency).gsub('OFFSET', offset)
  end
end
