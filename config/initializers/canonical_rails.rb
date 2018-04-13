CanonicalRails.setup do |config|
  # Parameter spamming can cause index dilution by creating seemingly different URLs with identical or near-identical content.
  # Unless whitelisted, these parameters will be omitted

  config.whitelisted_parameters = %i[keywords page search taxon]

  config.opengraph_url = true
end
