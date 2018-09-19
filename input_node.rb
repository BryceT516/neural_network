class InputNode
  def initialize
    @given_input = nil
  end

  def set_given_input(value)
    @given_input = value
  end

  def given_input
    @given_input
  end

  def current_value
    @given_input
  end

  def describe_itself
    puts @given_input
  end
end