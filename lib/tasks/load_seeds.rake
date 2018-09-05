namespace :load_seeds do
  desc 'Seed MV taxonomies'
  task mv_taxonomies: :environment do
    file = File.read(File.join(__dir__, '../../db/seeds/mv_taxonomies.json'))

    JSON.parse(file).each do |taxonomy, childs|
      taxonomy = Spree::Taxonomy.find_or_create_by!(name: taxonomy)

      parent_taxon = taxonomy.root
      childs.each do |taxon|
        parent_taxon.children.find_or_create_by!(name: taxon, taxonomy: taxonomy)
        p "Create taxon #{taxon} in #{parent_taxon.pretty_name}"
      end
    end
  end
end
