#!/usr/bin/ruby
# coding: utf-8

bad = " "

require "csv"
require "mechanize"

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

base = "http://www.hockey-reference.com/leagues"

table_xpath = '//*[@id="stats"]/tbody/tr'



(2017..2017).each do |year|

  if (year==2005)
    next
  end

  stats = CSV.open("csv/skaters_#{year}.csv","w")

  url = "#{base}/NHL_#{year}_skaters.html"
  print "Pulling year #{year}"

  begin
    page = agent.get(url)
  rescue
    retry
  end

  found = 0
  page.parser.xpath(table_xpath).each do |r|
    row = [year]
    r.xpath("td").each_with_index do |e,i|

      et = e.text
      if (et==nil) or (et.size==0)
        et=nil
      end

      if ([1,3].include?(i))

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
      stats << row
    end

  end

  print " - found #{found}\n"
  stats.close
end
