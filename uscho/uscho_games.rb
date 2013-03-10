#!/usr/bin/ruby1.9.1

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

d1_base = 'http://www.uscho.com/scoreboard/division-i-men'
d3_base = 'http://www.uscho.com/scoreboard/division-iii-men'

first_year = 2013
last_year = 2013

path = '//*[@id="scoreboard"]/table/tr'

(first_year..last_year).each do |year|

  print "Pulling #{year}\n"

  games = CSV.open("uscho_games_#{year}.csv","w")

  url = "#{d1_base}/#{year-1}-#{year}/composite-schedule/"

  begin
    page = agent.get(url)
  rescue
#    print "  -> #{year} not found\n"
    next
  end

  page.parser.xpath(path).each do |tr|
    row = [year]
    tr.xpath('td').each_with_index do |td,i|

      if ([4,7].include?(i))
        a = td.xpath("a").first
        if (a==nil)
          row += [td.text,nil,nil]
        else
          href = a.attribute("href").text
          team_id = href.split('/')[2]
          row += [td.text,team_id,href]
        end
      end
      row << td.text
    end
    games << row
  end

  url = "#{d3_base}/#{year-1}-#{year}/composite-schedule/"

  begin
    page = agent.get(url)
  rescue
#    print "  -> #{year} not found\n"
    next
  end

  page.parser.xpath(path).each do |tr|
    row = [year]
    tr.xpath('td').each_with_index do |td,i|

      if ([4,7].include?(i))
        a = td.xpath("a").first
        if (a==nil)
          row += [td.text,nil,nil]
        else
          href = a.attribute("href").text
          team_id = href.split('/')[2]
          row += [td.text,team_id,href]
        end
      end
      row << td.text
    end
    games << row
  end

end
