require 'Faker'

$i = 0
$num = 15370

while $i < $num  do
   puts Faker::Restaurant.name
   $i +=1
end
