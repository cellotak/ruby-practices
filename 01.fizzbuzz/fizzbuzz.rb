#数字を順番に表示
(1..20).each do |n|
  if n % 15 == 0  #3の倍数かつ5の倍数(即ち15の倍数)なら"FizzBuzz"を表示
    puts "FizzBuzz"
  elsif n % 3 == 0  #3の倍数なら"Fizz"を表示
    puts "Fizz"
  elsif n % 5 == 0  #5の倍数なら"Buzz"を表示
    puts "Buzz"
  else
    puts n
  end
end

