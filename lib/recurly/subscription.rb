module Recurly
  class Subscription < RecurlySingularResourceBase
    self.element_name = "subscription"
    self.prefix = "/accounts/:account_code"
    
    def self.refund(account_code, refund_type = :partial)
      raise "Refund type must be :full or :partial." unless refund_type == :full or refund_type == :partial
      Subscription.delete(nil, {:account_code => account_code, :refund => refund_type})
    end
    
    # Stops the subscription from renewing. The subscription remains valid until the end of
    # the current term (current_period_ends_at).
    def cancel
      Subscription.delete(self.subscription_account_code)
    end
    
    # Terminates the subscription immediately and processes a full or partial refund
    def refund(refund_type)
      raise "Refund type must be :full or :partial." unless refund_type == :full or refund_type == :partial
      Subscription.delete(nil, {:account_code => self.subscription_account_code, :refund => refund_type})
    end
    
    # Valid timeframe: :now or :renewal
    # Valid options: plan_code, quantity, unit_amount
    def change(timeframe, options = {})
      raise "Timeframe must be :full or :partial." unless timeframe == 'now' or timeframe == 'renewal'
      options[:timeframe] = timeframe
      connection.put(element_path(:account_code => self.subscription_account_code), 
        self.class.format.encode(options, :root => :subscription), 
        self.class.headers)
    end
    
    def subscription_account_code
      acct_code = self.account_code if defined?(self.account_code)
      acct_code ||= account.account_code if defined?(account) and !account.nil?
      acct_code ||= self.primary_key if defined?(self.primary_key)
      acct_code
    end
  end
end

