#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

results = CSV.open('uscho_teams.csv','w')

base = 'http://www.uscho.com/stats/history/'
url = 'http://www.uscho.com/stats/'

begin
  page = agent.get(url)
rescue
  print "  -> Page not found\n"
  exit
end

teams = []

team_path = '//*[@id="history_md1"]/option'

row_path = '//*[@class="odd" or @class="even"]'

page.parser.xpath(team_path).each do |team|
  team_id = team.attribute("value").text
  if not(team_id=='')
    teams << team_id
  end
end

team_path = '//*[@id="history_md3"]/option'

page.parser.xpath(team_path).each do |team|
  team_id = team.attribute("value").text
  if not(team_id=='')
    teams << team_id.strip
  end
end

teams.sort!.uniq!

teams.each do |team_id|

  url = "#{base}/#{team_id}/mens-hockey/"

  begin
    page = agent.get(url)
  rescue
    print "  -> #{team_id} not found\n"
    next
  end

  page.parser.xpath(row_path).each do |tr|
    row = [team_id]
    tr.xpath('td').each_with_index do |td,i|
      if (i==0)
        value=td.text.strip
        year = value.split('-')[0].to_i
        row += [year+1,value]
      else
        value = td.text
        if (value=='')
          row += [nil]
        else
          row += [value.strip]
        end
      end
    end
    results << row
  end

  results.flush

end

results.close

