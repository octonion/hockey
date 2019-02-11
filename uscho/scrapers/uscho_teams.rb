#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

results = CSV.open('csv/uscho_teams.csv','w')

base = 'http://www.uscho.com/stats/history/'
url = 'http://www.uscho.com/stats/'

begin
  page = agent.get(url)
rescue
  print "  -> Page not found\n"
  exit
end

teams = []

team_path = '//*[@id="team"]/option'
row_path = '//*[@class="odd" or @class="even"]'

page.parser.xpath(team_path).each do |team|
  value = team.attribute("value").text

  if not(value=='')
    s = value.split('/')
    team_id = s[3]
    league_id = s[4]
    #print "#{team_id} #{league_id}\n"
  else
    next
  end

  if league_id=='mens-hockey'
    teams << team_id
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
