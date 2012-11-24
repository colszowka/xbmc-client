$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'httparty'
require 'ruby_ext'
require 'active_support/core_ext'

# A simple XBMC JSON RPC API Client. See README for details.
class Xbmc
  # Error class for indicating trouble with authentication against the XBMC Api
  class UnauthorizedError < StandardError; end;
  
  include HTTParty

  class << self
    # API interaction: Invokes the given method with given params, parses the JSON response body, maps it to
    # a HashWithIndifferentAccess and returns the :result subcollection
    def invoke_and_process(method, params={})
      JSON.parse(invoke_method(method, params).body).with_indifferent_access[:result]
    end
    
    # Raw API interaction: Invoke the given JSON RPC Api call and return the raw response (which is an instance of
    # HTTParty::Response)
    def invoke_method(method, params={})
      response = post('/jsonrpc', :body => {"jsonrpc" => "2.0", "params" => params, "id" => "1", "method" => method}.to_json)
      raise Xbmc::UnauthorizedError, "Could not authorize with XBMC. Did you set up your credentials for basic_auth using Xbmc.basic_auth 'user', 'pass'?" if response.response.class == Net::HTTPUnauthorized
      response
      
    # Capture connection errors and send them out with a custom message
    rescue Errno::ECONNREFUSED, SocketError, HTTParty::UnsupportedURIScheme => err
      raise err.class, err.message + ". Did you configure the url and port for XBMC properly using Xbmc.base_uri 'http://localhost:1234'?"
    end

    # Returns an array of available api commands instantiated as Xbmc::Command objects
    def commands
      # Get API version number because of changes in the API starting with Eden (v3)
      version = invoke_and_process("JSONRPC.Version")

      if (version["version"] == 2)
      # XBMC Dharma
        @commands ||= invoke_and_process("JSONRPC.Introspect", :getdescriptions => true)[:commands].map {|c| Xbmc::Command.new(c)}
      else
      # XBMC Eden 
        @commands ||= invoke_and_process("JSONRPC.Introspect", :getdescriptions => true)[:methods].map {|c| 
          # Get the command specification
          attrList = c.at(1)
          
          # Add command name to the specification
          attrList["command"] = c.at(0)
          
          # Process the command as usual
          Xbmc::Command.new(attrList)
        }
      end
    end

    # Loads the available commands via JSONRPC.Introspect and defines the namespace classes and corresponding methods
    # in the ruby namespace
    def load_api!
      return false if @api_loaded
      commands.each do |command|
        command.send :define_method!
      end
      @api_loaded = true
    end
  end
end

require 'xbmc/command'
