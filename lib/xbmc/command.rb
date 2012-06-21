# Representation of a XBMC JSON RPC method
class Xbmc::Command
  attr_reader :command, :namespace, :method_name, :original_method, :description

  # Initializes a new command from the meta data hash given in JSONRPC.Introspect
  def initialize(command_meta)
    @command_meta = command_meta.with_indifferent_access
    @description = command_meta[:description]
    @command = command_meta[:command]
    parse_command!
  end

  # Invokes this command and processes the result
  def invoke(params={})
    process_result(Xbmc.invoke_and_process(command, params))
  end
  
  # The ruby class name this command should end up in
  def klass_name
    "Xbmc::#{namespace}"
  end
  
  private

  # Extract the namespace and method names from the given JSON RPC raw command name
  def parse_command!
    @namespace, @original_method = command.split('.')
    @method_name = original_method.underscore
  end

  # Will create the corresponding class for namespace if not defined yet
  # and also define the given method
  def define_method!
    begin
      klass = klass_name.constantize
    rescue NameError => err
      eval("#{klass_name} = Class.new")
      klass = klass_name.constantize
    end
  
    # Need to assign instance to local var because "self" is out of scope inside the method definition
    command_object = self
    # Define class method in corresponding namespace class
    klass.metaclass.send(:define_method, method_name.to_sym) do |*args|
      command_object.invoke(*args)
    end
  end

  # Will return the subcollection "xyz" from the response for "get_xyz" commands when
  # the collection is present, or just the result collection otherwise.
  def process_result(result)
    begin
      if method_name =~ /^get_(.+)/ and (collection = result[$1.gsub('_', '')]).present?
        return collection
      else
        return result
      end
    rescue
      return result
    end
  end
end
