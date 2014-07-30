require "./lib/mappings"

module Stringifier
  include Mappings

  def stringify(input)
    array = []
    p_stringify(input, array)
    return array.join(' ').sub('  ', ' ').rstrip
  end

  private

  def stringify_two_digit_number(input_string)
    return if input_string.length > 2 || input_string.to_i == 0

    # numbers 1-9
    if input_string.to_i < 10 and input_string.to_i > 0
      return singles[input_string[1,2]]
    end

    # numbers 11-19
    if input_string.to_i < 20 and input_string.to_i > 10
      return teens[input_string]
    end

    # numbers 10, 20, 30, 40, 50, 60, 70, 80, 90
    if input_string[0,1].to_i != 0 and input_string[1,2].to_i == 0
      return tens[input_string[0,1]]
    end

    # numbers between 21-99 that are not divisible by 0
    if input_string.to_i > 20 and input_string.to_i < 99
      return tens[input_string[0,1]] + '-' + singles[input_string[1,2]]
    end
  end

  def stringify_with_descriptor(input_string, descriptor = nil)
    return if input_string.length > 3 || input_string.to_i == 0
    array = []
    two_digit_number = ''

    input_string = input_string.to_i.to_s 

    if input_string.length ==  1
      array.push(singles[input_string])
    elsif input_string.length == 2
      two_digit_number = stringify_two_digit_number(input_string)
    elsif input_string.length == 3
      two_digit_number = stringify_two_digit_number(input_string[1,3])
      array.push(singles[input_string[0,1]])
      array.push('hundred')
    end

    array.push(two_digit_number) unless two_digit_number == nil
    array.push(descriptor) unless descriptor == nil
    return array
  end


  def p_stringify(number, return_array = [])
    string = number.to_s.split('.')[0].to_s
    decimal = number.to_s.split('.')[1].to_s
    number_length = string.length
    return "Number too large." if number_length > 15

    if number_length > 12
      difference = number_length - 12
      current_substring = string[0, difference]
      new_substring = string[difference, (string.length - 1)]

      return_array.push(stringify_with_descriptor(current_substring, 'trillion'))
      p_stringify(new_substring, return_array)
    elsif number_length > 9
      difference = number_length - 9
      current_substring = string[0, difference]
      new_substring = string[difference, (string.length - 1)]

      return_array.push(stringify_with_descriptor(current_substring, 'billion'))
      p_stringify(new_substring, return_array)
    elsif number_length > 6
      difference = number_length - 6
      current_substring = string[0, difference]
      new_substring = string[difference, (string.length - 1)]
      return_array.push(stringify_with_descriptor(current_substring, 'million'))
      p_stringify(new_substring, return_array)
    elsif number_length > 3
      difference = number_length -  3
      current_substring = string[0, difference]
      new_substring = string[difference, (string.length - 1)]

      return_array.push(stringify_with_descriptor(current_substring, 'thousand'))
      p_stringify(new_substring, return_array)
    elsif number_length > 0
      difference = number_length
      current_substring = string[0, difference]
      return_array.push(stringify_with_descriptor(current_substring))
    end

    unless decimal == nil || decimal.to_i == 0
      decimal_length = decimal.length
      decimal_string = ''

      return_array.push('and')
      decimal_string << decimal + '/1'

      for i in 1..decimal_length
        decimal_string << '0'
      end

      return_array.push(decimal_string)
    end

    #return return_array
  end
end


