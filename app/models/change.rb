class Change
  attr_reader :value


  ALLOWED_VALUES = [1, 2, 5, 10, 20, 50, 100, 200]


  def initialize value
    @value = case value
             when /(?<int_value>\d+)p/
               $1.to_i
             when /£(?<int_value>\d+)/
               $1.to_i * 100
             else
               raise ArgumentError, 'unknown value'
             end

    unless ALLOWED_VALUES.include?(@value)
      raise ArgumentError, "allowed values are #{ALLOWED_VALUES.join(',')}"
    end
  end


  def <=(_value)
    value <= _value
  end


  # Prevent float operations imprecision, such as subtraction,
  # by operationg on BigDecimal type
  def value
    BigDecimal.new(@value / 100.0, 2)
  end
end
