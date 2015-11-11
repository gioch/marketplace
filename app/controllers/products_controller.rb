class ProductsController < ApplicationController
  before_action :set_product, except: [:index, :new]
  before_action :set_categories, only: [:index, :seller, :new]
  before_filter :authenticate_user!, except: [:index]
  before_filter :check_user, only: [:edit, :update, :destroy]


  def index
    @products = Product.latest_by_category(params['category_id'])
  end

  def seller
    @products = Product.latest_by_category_for_user(current_user, params['category_id'])
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    if @product = Product.new(product_params)
      current_user.products << @product
      set_users_recipient(current_user)
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to product_url, notice: 'Product was successfully destroyed.'
  end

  private
    def set_users_recipient(user)
      if user.recipient_blank?
        recipient = CreditCardService.new({ name: user.name, token: params[:stripeToken] }).create_recipient
        user.set_recipient_id(recipient.id) unless recipient.nil?
      end
    end

    def set_product
      @product = Product.find(params[:id]) rescue nil
    end

    def set_categories
      @categories = Category.all
    end

    def product_params
      params.require(:product).permit(:id, :name, :category_id, :description, :price, :image)
    end

    def check_user
      redirect_to root_url, alert: "Sorry, this product belongs to someone else" unless @product.belongs_to_user?(current_user)
    end
end
