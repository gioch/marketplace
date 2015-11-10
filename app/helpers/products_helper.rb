module ProductsHelper
  def show_product_create_button
    link_to 'New Product', new_product_path, class: "btn btn-link", data: { no_turbolink: true } if user_signed_in? 
  end

  def show_product_edit_button(product)
    link_to 'Edit', edit_product_path(product), class: "btn btn-link" if product.belongs_to_user?(current_user)
  end

  def show_product_delete_button(product)
    link_to 'Destroy', product, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-link" if product.belongs_to_user?(current_user)
  end
end
