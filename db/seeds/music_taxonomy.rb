music_taxonomy = Spree::Taxonomy.find_or_create_by!(name: 'Music')

CSV.foreach(File.join(__dir__, 'music.csv'), headers: false) do |row|
  taxon = row.first
  parent_taxon = music_taxonomy.root
  parent_taxon.children.find_or_create_by!(name: taxon, taxonomy: music_taxonomy)
  p "Created taxon #{taxon} in #{parent_taxon.pretty_name}"
end
