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

connect = lambda { Redis.new(:db =>2) }
@r = connect.call
@r.flushdb #start from a clean slate. Be careful!

def add_to_list(list_name, file_name)
  csv = CSV.read(file_name)

  csv.each do |entry|
    @r.hmset entry[0], "id", entry[0], "email", entry[1], "status", entry[2]
    @r.sadd(list_name, entry[0]) if entry[2] == "Active"
  end
end

pid1 = fork do
  @r = connect.call
  add_to_list "list_one", "/home/brycemcd/Desktop/all_subscribers_trunc.csv"
end

pid2 = fork do
  @r = connect.call
  add_to_list "list_two", "/home/brycemcd/Desktop/daily_event_trunc.csv"
end

Process.wait pid1
Process.wait pid2

@r.sdiffstore "list_diff", "list_one", "list_two"

CSV.open("data/diff.csv", "wb") do |csv|
  @r.smembers("list_diff").each do |diff|
    csv << @r.hmget(diff, "id", "email", "status")
  end
end
