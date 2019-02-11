#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

d1_base = 'https://www.uscho.com/scoreboard/division-i-men'
d3_base = 'https://www.uscho.com/scoreboard/division-iii-men'

first_year = ARGV[0].to_i
last_year = ARGV[1].to_i

#//*[@id="teamsked"]/tbody/tr[498]
#path = '//tr[@role="row"]'
#'//section[@id="scoreboard"]/table/tr'
path = '//*[@id="teamsked"]/tbody/tr'

(first_year..last_year).each do |year|

  print "Pulling #{year}\n"

  games = CSV.open("csv/uscho_games_#{year}.csv","w")

  url = "#{d1_base}/#{year-1}-#{year}/composite-schedule/"
  
  begin
    page = agent.get(url)
  rescue
    print "  -> #{year} not found\n"
    next
  end

  page.parser.xpath(path).each do |tr|
    #print(tr)
    row = [year]
    tr.xpath('td').each_with_index do |td,i|

      if ([4,7].include?(i))
        a = td.xpath("a").first
        if (a==nil)
          if (td.text.size==0)
            row += [nil,nil,nil]
          else
            row += [td.text.strip,nil,nil]
          end
        else
          href = a.attribute("href").text
          team_id = href.split('/')[2]
          row += [td.text.strip,team_id,href]
        end
      end
      if (td.text.size==0)
        row += [nil]
      else
        row += [td.text.strip]
      end
    end
    games << row
  end

  games.flush

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
          if (td.text.size==0)
            row += [nil,nil,nil]
          else
            row += [td.text.strip,nil,nil]
          end
        else
          href = a.attribute("href").text
          team_id = href.split('/')[2]
          row += [td.text.strip,team_id,href]
        end
      end
      if (td.text.size==0)
        row += [nil]
      else
        row += [td.text.strip]
      end
    end
    games << row
  end

  games.close

end
