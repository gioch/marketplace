class StripeClient
  def initialize(token)
    @token = token
    set_app_key
  end

  def create_recipient(user_name)
    begin
      Stripe::Recipient.create(:name => user_name, :type => "individual", :bank_account => @token)
    rescue => e
      @errors = e.message
      nil
    end
  end

  def charge(price)
    begin
      Stripe::Charge.create(:amount => (price * 100).floor, :currency => "usd", :card => @token)
    rescue Stripe::CardError => e
      @errors = e.message
      nil
    end
  end

  def errors
    @errors
  end

  private
  def set_app_key
    Stripe.api_key = STRIPE_KEYS["API_KEY"]
  end
end
