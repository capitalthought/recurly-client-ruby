# Recurly is a Ruby client for Recurly's REST API.
module Recurly
  autoload :Account,      'recurly/account'
  autoload :AddOn,        'recurly/add_on'
  autoload :Adjustment,   'recurly/adjustment'
  autoload :API,          'recurly/api'
  autoload :BillingInfo,  'recurly/billing_info'
  autoload :Coupon,       'recurly/coupon'
  autoload :Helper,       'recurly/helper'
  autoload :Invoice,      'recurly/invoice'
  autoload :JS,           'recurly/js'
  autoload :Money,        'recurly/money'
  autoload :Plan,         'recurly/plan'
  autoload :Redemption,   'recurly/redemption'
  autoload :Resource,     'recurly/resource'
  autoload :Subscription, 'recurly/subscription'
  autoload :Transaction,  'recurly/transaction'
  autoload :Version,      'recurly/version'
  autoload :XML,          'recurly/xml'

  # The exception class from which all Recurly exceptions inherit.
  class Error < StandardError
    def set_message message
      @message = message
    end

    # @return [String]
    def to_s
      defined? @message and @message or super
    end
  end

  # This exception is raised if Recurly has not been configured.
  class ConfigurationError < Error
  end

  class << self
    # @return [String] An API key.
    # @raise [ConfigurationError] If not configured.
    def api_key
      defined? @api_key and @api_key or raise(
        ConfigurationError, "Recurly.api_key not configured"
      )
    end
    attr_writer :api_key

    # @return [String, nil] A default currency.
    def default_currency
      return @default_currency if defined? @default_currency
      @default_currency = 'USD'
    end
    attr_writer :default_currency

    # @return [JS] The Recurly.js module.
    def js
      JS
    end

    # Assigns a logger to log requests/responses and more.
    #
    # @return [Logger, nil]
    # @example
    #   require 'logger'
    #   Recurly.logger = Logger.new STDOUT
    # @example Rails applications automatically log to the Rails log:
    #   Recurly.logger = Rails.logger
    # @example Turn off logging entirely:
    #   Recurly.logger = nil # Or Recurly.logger = Logger.new nil
    attr_accessor :logger

    # Convenience logging method includes a Logger#progname dynamically.
    # @return [true, nil]
    def log level, message
      if logger
        logger.send(level, name) { message }
      elsif level == :warn
        warn message
      end
    end
  end
end

require 'rails/recurly' if defined? Rails::Railtie
