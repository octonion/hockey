#!/usr/bin/ruby
# coding: utf-8

bad = " "

require "csv"
require "mechanize"

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

base = "http://www.hockey-reference.com/leagues"

table_xpath = '//*[@id="games_playoffs"]/tbody/tr'

first_year = ARGV[0].to_i
last_year = ARGV[1].to_i

(first_year..last_year).each do |year|

  if (year==2005)
    next
  end

  stats = CSV.open("csv/playoffs_#{year}.csv","w")

  url = "#{base}/NHL_#{year}_games.html"
  print "Pulling year #{year}"

  begin
    page = agent.get(url)
  rescue
    retry
  end

  found = 0
  page.parser.xpath(table_xpath).each do |r|
    row = [year]
    r.xpath("td|th").each_with_index do |e,i|

      et = e.text
      if (et==nil) or (et.size==0)
        et=nil
      end

      if ([0,1,3].include?(i))

        if (e.xpath("a").first==nil)
          row += [et,nil]
        else
          row += [et,e.xpath("a").first.attribute("href").to_s]
        end

      else

        row += [et]

      end

    end

    if (row.size>1)
      found += 1
      #if (row.size == 10)
      #  row += [nil]
      #end
      stats << row
    end

  end

  print " - found #{found}\n"
  stats.close
end
