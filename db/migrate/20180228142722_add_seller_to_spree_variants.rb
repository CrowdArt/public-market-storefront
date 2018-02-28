class AddSellerToSpreeVariants < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_variants, :seller, :text
  end
end
