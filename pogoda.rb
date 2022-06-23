# Подключаем необходимые либы
require 'net/http' # для загрузки данных по HTTP
require 'uri' # для работы с адресами URI
require 'rexml/document' # для парсинга xml-файлов
require 'cgi' # для раскодирования данных с сайта погоды (город)
require 'date' # для работы с датами
# Подключаем необходимые классы
require_relative 'lib/meteoservice_forecast'

# Определяем список доступных городов:
cities = { 1 => [34, "Минск"],
           2 => [2895, "Брест"],
           3 => [2897, "Витебск"],
           4 => [2900, "Гомель"],
           5 => [2896, "Гродно"],
           6 => [35, "Могилёв"]}

# Запрашиваем инфо у пользователя
puts "Погоду для какого города Вы хотели бы узнать?"
cities.each_pair do |number, city|
  puts "#{number}: #{city[1]}"
end

choice = nil
until (1..cities.size).include?(choice)
  choice = STDIN.gets.chomp.to_i
end

# Фиксируем наш URL
city_code = cities[choice][0].to_s
url = "https://xml.meteoservice.ru/export/gismeteo/point/#{city_code}.xml"

# Отправляем запрос по uri-адресу и сохраняем результат в переменную
response = Net::HTTP.get_response(URI.parse(url))

# Парсим полученный в ответе xml
doc = REXML::Document.new(response.body)

# Определяем город и время запроса прогноза погоды
city_name = CGI.unescape(doc.root.elements["REPORT/TOWN"].attributes["sname"])
time = Time.now

# Достаем все элементы <FORECAST> внутри тега <TOWN> (погода) и складываем в массив
forecast_nodes = doc.root.elements["REPORT/TOWN"].elements.to_a

# Выводим информацию о городе и времени запроса погоды на экран
puts "Город #{city_name}."
puts "Время запроса прогноза погоды: #{time}."
puts

# Проходимся по всем элементам полученного массива, создаем объекты и выводим информацию на экран
forecast_nodes.each do |element|
  weather = MeteoserviceForecast.new(element)
  weather.show_weather
end