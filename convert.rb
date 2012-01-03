# encoding: utf-8
require "csv" if RUBY_VERSION =~ /^1\.9/

MyCSV = (RUBY_VERSION =~ /^1\.9/ ? CSV : FasterCSV)

file = ARGV[0]

def parse_coordinate(str)
  deg, r = str.split("°")
  min, sec = str.split("′")
  sec ||= "0"
  deg, min, sec = [deg, min, sec].map { |a| a.to_i }
  deg + min / 60.0 + sec / 3600.0
end

def parse_coordinates(str)
  if str
    str.split(",").map { |c| parse_coordinate(c) }
  else
    [nil, nil]
  end
end

def number_or_nil(v)
  if v
    v
  else
    "nil"
  end
end

CSV.foreach(file, :encoding => Encoding::UTF_8) do |row|
  unless row[0] == "Name"
    lat, lon = parse_coordinates(row[2])
    reg = row[1] == "" ? nil : row[1]
    puts "Airfield.create :name => '#{row[0]}', :lat => #{number_or_nil(lat)}, :lon => #{number_or_nil(lon)}, :registration => " + (reg.nil? ? "nil" : "'#{reg}'")
  end
end
