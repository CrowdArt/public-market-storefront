# This migration comes from spree_multi_vendor (originally 20180129144617)
class AddNoteToSpreeVendors < SpreeExtension::Migration[5.1]
  def change
    add_column :spree_vendors, :note, :text
  end
end
