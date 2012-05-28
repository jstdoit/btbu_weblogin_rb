require './exceptions'
class WebLoginResponse
  
  attr_accessor :code, :info
  def initialize res
    @response = res.body.to_s.strip.encode 'utf-8', 'gbk'
    self.parse
  end
  
  def parse
    raise Exception if @response.empty?
    arr = @response.split '.'
    @code = arr[0]
    @info = arr[1]

    case @code
      
    when "E005"
      raise AccountOnlineException.new "acc already online"
    end
  end
  
  def to_s
    puts "code = #{@code}, info = #{@info}"
  end
end