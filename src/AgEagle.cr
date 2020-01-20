require "kemal"
require "http/client"

get "/" do
  "Hello World!"
end

def rand(max)
  response = HTTP::Client.get "https://www.random.org/integers/?num=1&min=1&max=#{max}&col=1&base=10&format=plain&rnd=new"
  response.status_code # => 200
  response.body.lines.first.to_i
end

def randomCoordinate
  degrees = rand(90)
  minutes = rand(60)
  seconds = rand(3600)
  longitude_directions = [-1, 1]
  direction = longitude_directions[Random.rand(longitude_directions.size)]

  degrees2 = rand(180)
  minutes2 = rand(60)
  seconds2 = rand(3600)
  latitude_directions = [-1, 1]
  direction2 = latitude_directions[Random.rand(latitude_directions.size)]
  # [{degrees: degrees, minutes: minutes, seconds: seconds}, {degrees: degrees2, minutes: minutes2, seconds: seconds2}]
  [(degrees.to_f + minutes.to_f/60 + seconds.to_f/3600) * direction, (degrees2.to_f + minutes2.to_f/60 + seconds2.to_f/3600) * direction2]
end

def getWeather(coord)
  lat = coord[0]
  lon = coord[1]
  response = HTTP::Client.get "https://samples.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=b6907d289e10d714a6e88b30761fae22"
  response.status_code # => 200
  response.body
end

get "/points/:points" do |env|
  points = env.params.url["points"]
  getWeather(randomCoordinate)
end

Kemal.run
