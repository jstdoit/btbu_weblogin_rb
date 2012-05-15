module MakeRequest 
  def sendRequest cmd
    post.set_form_data data
    response = http.start {|http| http.request post}

    result = WebLoginResponse.new response
  end
end