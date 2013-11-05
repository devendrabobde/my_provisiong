class Password < String

  ALPHANUMERIC = ("A".."Z").to_a + ("a".."z").to_a + ("0".."9").to_a
  LENGTH_RANGE = (50..80)

  def initialize
    super(generate_new_password)
  end

  private
  def generate_new_password
    random_length = LENGTH_RANGE.to_a.sample
    (1..random_length).collect {ALPHANUMERIC.sample}.join
  end
end
