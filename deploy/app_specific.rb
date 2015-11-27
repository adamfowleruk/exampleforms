#
# Put your custom functions in this class in order to keep the files under lib untainted
#
# This class has access to all of the private variables in deploy/lib/server_config.rb
#
# any public method you create here can be called from the command line. See
# the examples below for more information.
#
class ServerConfig

  #
  # You can easily "override" existing methods with your own implementations.
  # In ruby this is called monkey patching
  #
  # first you would rename the original method
  # alias_method :original_deploy_modules, :deploy_modules

  # then you would define your new method
  # def deploy_modules
  #   # do your stuff here
  #   # ...

  #   # you can optionally call the original
  #   original_deploy_modules
  # end

  #
  # you can define your own methods and call them from the command line
  # just like other roxy commands
  # ml local my_custom_method
  #
  # def my_custom_method()
  #   # since we are monkey patching we have access to the private methods
  #   # in ServerConfig
  #   @logger.info(@properties["ml.content-db"])
  # end

  #
  # to create a method that doesn't require an environment (local, prod, etc)
  # you woudl define a class method
  # ml my_static_method
  #
  # def self.my_static_method()
  #   # This method is static and thus cannot access private variables
  #   # but it can be called without an environment
  # end

 alias_method :original_deploy_modules, :deploy_modules

  def deploy_modules
    original_deploy_modules

    deploy_test_specific_config
  end

  def deploy_test_specific_config
    app_config_file = File.join @properties['ml.xquery.dir'], "/app/config/config.xqy"

        #have test specific config
        if File.exist? app_config_file
            src_permissions = permissions(@properties['ml.app-role'], Roxy::ContentCapability::ER)
            src_permissions.push permissions('rest-admin', Roxy::ContentCapability::RU)
            src_permissions.push permissions('rest-extension-user', Roxy::ContentCapability::EXECUTE)
            src_permissions.flatten!

            buffer = File.read app_config_file

            buffer.gsub!("@ml.workflow-service-address", @properties['ml.test-workflow-service-address'])
            buffer.gsub!("@ml.workflow-service-username", @properties['ml.test-workflow-service-username'])
            buffer.gsub!("@ml.workflow-service-password", @properties['ml.test-workflow-service-password'])

            xcc.load_buffer "/config.xqy",
                            buffer,
                            :db => @properties['ml.test-modules-db'],
                            :add_prefix => File.join(@properties["ml.modules-root"], "app/config"),
                            :permissions => src_permissions
        end
  end

end
