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

csv_one = CSV.read("/home/brycemcd/Desktop/all_subscribers.csv")

csv_one.each do |entry|
  $r.hmset entry[0], "id", entry[0], "email", entry[1], "status", entry[2]
  $r.sadd("list_one", entry[0]) if entry[2] == "Active"
end

csv_two = CSV.read("/home/brycemcd/Desktop/daily_event.csv")

csv_two.each do |entry|
  $r.hmset entry[0], "id", entry[0], "email", entry[1], "status", entry[2]
  $r.sadd("list_two", entry[0]) if entry[2] == "Active"
end

$r.sdiffstore "list_diff", "list_one", "list_two"

CSV.open("data/diff.csv", "wb") do |csv|
  $r.smembers("list_diff").each do |diff|
    csv << $r.hmget(diff, "id", "email", "status")
  end
end
