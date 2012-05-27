module Weblogin

	require 'exceptions'
	require 'command'
	require 'net/http'
	require 'net/https'
	require 'uri'
	require 'weblogin_config'
	require 'yaml'

	# get rid of the verify warning.
	class Net::HTTP
	  alias_method :old_initialize, :initialize
	  def initialize(*args)
	    old_initialize(*args)
	    @ssl_context = OpenSSL::SSL::SSLContext.new
	    @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
	  end
	end

	class WebLogin
		SERVER_URL = "https://weblogin.btbu.edu.cn/cgi-bin/netlogincgi.cgi"

		# used for login 
		# @param username UserName for Login
		# @param password Password for Login
		def login username, password
			@pack_data[:account] = username
			@pack_data[:password] = password


			result = do_req CMD[:LOGIN]

			if result[:res_code].eql? 'S201'
				puts "#{result[:res_info]}"

				options = {:username => username}
				File.open CONFIG_FILE, 'w' do |file|
					YAML.dump options, file
				end
				do_poll
			else
				puts "#{result[:res_info]}"
			end
		end


		# used for logout
		# @param username username for logout
		def logout username
			@pack_data[:account] = username

			result = do_req CMD[:LOGOUT]

			puts "#{result[:res_info]}"
		end

		# used for get the information of account
		# @param username UserName for Information
		# @param password Password for Information
		def info username, password
			@pack_data[:account] = username
			@pack_data[:password] = password

			result = do_req CMD[:CHECK]
			puts "Your Account Info:\n #{result[:res_info]}" 
		end

		def initialize

			@pack_data = {}

			@uri = URI.parse SERVER_URL
			@http = Net::HTTP.new @uri.host, 443
			@http.use_ssl = true

		end

		private 

			# used for Poll the login action
			def do_poll
				puts do_req(CMD[:POLL])[:res_info]
			  while true do 
			    sleep 2 
			  	result = do_req CMD[:POLL]
			  	if result[:res_code] == 'S205'
			  		puts "#{result[:res_info]}"
			  	end
			  end
			end

			#used for sending request
			def do_req cmd_code
				@pack_data[:netlogincmd] = cmd_code

				post = Net::HTTP::Post.new @uri.path
				post.set_form_data @pack_data
				response = @http.start {|http| @http.request post}

				parse_response response
			end

			def parse_response res
				result = {}
				unless @pack_data[:netlogincmd] == CMD[:CHECK]
					response_a = res.body.to_s.strip.encode.split '.'
					if response_a[0].start_with? 'S'
						result[:res_info] = "Suc: #{response_a[1]}"
					else
						result[:res_info] = "Err: #{response_a[1]}"
					end
					result[:res_code] = response_a[0]
				else
					result = {:res_info => res.body.to_s.strip.encode, :res_code => 'S110'}
				end
				#return 
				result
			end


	end
end