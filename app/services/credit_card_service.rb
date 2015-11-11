class CreditCardService
  def initialize(params)
    @token = params[:token]
    @customer_name = params[:name]
    @price = params[:price]
    @currency = params[:currency] || 'usd'
    set_app_key
  end

  def create_recipient
    begin
      external_customer_service.create(customer_attributes)
    rescue => e
      @errors = e.message
      nil
    end
  end

  def charge
    begin
      external_charge_service.create(charge_attributes)
    rescue => e
      @errors = e.message
      nil
    end
  end

  def errors
    @errors
  end

  private

  def charge_attributes
    { :amount => (@price * 100).floor, :currency => @currency, :card => @token }
  end

  def customer_attributes
    { :name => @customer_name, :type => 'individual', :bank_account => @token }
  end

  def external_customer_service
    Stripe::Recipient
  end

  def external_charge_service
    Stripe::Charge
  end

  def set_app_key
    Stripe.api_key = STRIPE_KEYS["API_KEY"]
  end
end
