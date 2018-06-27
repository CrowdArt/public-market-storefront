categories = Spree::Taxonomy.find_or_create_by!(name: 'Books')

CSV.foreach(File.join(__dir__, 'bisac.csv'), headers: false) do |row|
  taxons = row.last.split(' / ')

  parent_taxon = categories.root
  taxons.each do |taxon|
    parent_taxon = parent_taxon.children.find_or_create_by!(name: taxon, taxonomy: categories)
    p "Create taxon #{taxon} in #{parent_taxon.pretty_name}"
  end
end
