require_relative "../user.rb"

n = 1

1000000.times do
  str = 8.times.map{('A'..'Z').to_a[rand(26)]}.join
  User.create!(name: str, address: str, tel: str)
  puts n
  n += 1
end