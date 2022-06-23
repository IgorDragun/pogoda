# Определяем класс
class MeteoserviceForecast
  # Определим констатнту для для атмосферных явлений
  CLOUDINESS_TYPE = {-1 => "туман",
                     0 => "ясно",
                     1 => "малоооблачно",
                     2 => "облачно",
                     3 => "пасмурно"}.freeze

  # Определим констатнту для времени суток
  DAY_TIME = {0 => "ночь",
              1 => "утро",
              2 => "день",
              3 => "вечер"}.freeze

  # Определим конструктор
  def initialize(array_info)
    # Наполняем наш объект данными из xml
    # Дата и время суток
    @day = array_info.attributes["day"].to_i
    @month = array_info.attributes["month"].to_i
    @year = array_info.attributes["year"].to_i
    @date = Date.parse("#{@day}.#{@month}.#{@year}").strftime("%d.%m.%Y")
    @day_time = array_info.attributes["tod"].to_i
    # Температура
    @temperature_min = array_info.elements["TEMPERATURE"].attributes["min"].to_i
    @temperature_max = array_info.elements["TEMPERATURE"].attributes["max"].to_i
    # Ветер
    @wind = array_info.elements["WIND"].attributes["max"].to_i
    # Атмосферные явления
    @cloudiness = array_info.elements["PHENOMENA"].attributes["cloudiness"].to_i
  end

  # Определяем метод для вывода данных объекта на экран
  def show_weather
    print day?
    puts DAY_TIME[@day_time]
    print "Температура воздуха: #{temperature_range_string}, "
    print "Ветер #{@wind} м/с, "
    puts "#{CLOUDINESS_TYPE[@cloudiness]}."
    puts
  end

  def day?
    if @day == Date.today.day.to_i
      "Сегодня, "
    else
      "#{@date}, "
    end
  end

  def temperature_range_string
    result = ""
    result << "-#{@temperature_min}" if @temperature_min < 0
    result << "#{@temperature_min}" if @temperature_min == 0
    result << "+#{@temperature_min}" if @temperature_min > 0
    result << ".."
    result << "-#{@temperature_max}" if @temperature_max < 0
    result << "#{@temperature_max}" if @temperature_max == 0
    result << "+#{@temperature_max}" if @temperature_max > 0
    result
  end

end