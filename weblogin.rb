#!/usr/local/bin/ruby
require 'net/http'
require 'net/https'
require 'uri'
require './response'

begin
uri = URI.parse "https://weblogin.btbu.edu.cn/cgi-bin/netlogincgi.cgi"
http = Net::HTTP.new uri.host, 443
post = Net::HTTP::Post.new uri.path
http.use_ssl = true
# headers = {
#   'Content-Type' => 'application/x-www-form-urlencoded',
#   'Accept-Charset' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
#   'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.163 Safari/535.19',
#   'Host' => 'weblogin.btbu.edu.cn',
#   'Origin' => 'https://weblogin.btbu.edu.cn',
#   'Referer' => 'https://weblogin.btbu.edu.cn/',
#   'Connection' => 'keep-alive',
#   'Accept' => '*/*',
#   'Accept-Encoding' => 'gzip,deflate,sdch'
# }
#
# netlogincmd code 
# 0 logout
# 1 login
# 2 change password
# 3 check account info
# 4
# 5 poll request

cmd = {
  'LOGOUT' => 0,
  'LOGIN' => 1,
  'CHGPWD' => 2,
  'CHECK' => 3,
  'POLL' => 5
}

data = {
  # 'cinfo' => 'cinfo',
  # 'einfo' => 'einfo',
  # 'chgpwd' => 'chgpwd',
  # 'logout' => 'Logout',
  # 'login' => 'Login',
  'netlogincmd' => cmd['LOGIN'],
  # 'proxyip' => '127.0.0.1',
  'password' => '111111',
  'account' => '0714010108'
}
post.set_form_data data
response = http.start {|http| http.request post}

result = WebLoginResponse.new response

if result.code == "S201"
  puts result.info
  data['netlogincmd'] = cmd['POLL']
  post.set_form_data data
  while true do 
    result = WebLoginResponse.new http.start{|http| http.request post}
    puts result.info
    sleep 30
  end
else
  puts 'Some error happened.'
end

rescue AccountOnlineException => e
  puts 'exception: ' << e.to_s
  data['netlogincmd'] = cmd['LOGOUT']
  post.set_form_data data
  res = WebLoginResponse.new http.start {|http| http.request post}
  puts res.info
end
