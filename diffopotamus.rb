%w(
csv
redis
).each do |dep|
  begin
    require dep
  rescue => e
    puts "requires #{dep} not available"
  end
end

$r = Redis.new(:db =>2)

list_one = CSV.read("/home/brycemcd/Desktop/all_subscribers.csv")

list_one.each { |entry| $r.sadd("list_one", entry[1]) if entry[2] == "Active" }

list_two = CSV.read("/home/brycemcd/Desktop/daily_event.csv")

list_two.each { |entry| $r.sadd("list_two", entry[1]) if entry[2] == "Active" }
