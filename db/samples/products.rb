require 'ffaker'

5.times do
  name = FFaker::Book.title
  product =
    Spree::Product.where(name: name).first_or_initialize do |prod|
      prod.price = Random.rand(20)
      prod.description = FFaker::Book.description
      prod.available_on = Time.zone.now

      prod.shipping_category = Spree::ShippingCategory.first_or_create(name: 'Default')

      prod
    end

  sku = FFaker::IdentificationMX.curp
  product.master = Spree::Variant.where(sku: sku, is_master: true).first_or_initialize do |master|
    master.sku = sku
    master.price = Random.rand(20)
    master.option_values = Spree::OptionValue.order('RANDOM()').first(2)

    image_path =
      "https://orly-appstore.herokuapp.com/generate?title=#{name}&"\
      'top_text=Thanks%20to%20dev.to&'\
      'author=Artem&'\
      "image_code=#{Random.rand(1..40)}&"\
      "theme=#{Random.rand(1..16)}&"\
      "guide_text=#{product.description}&"\
      'guide_text_placement=bottom_right'

    master.images =
      [
        Spree::Image.new(
          attachment: URI.parse(image_path),
          position: 0
        )
      ]
  end

  product.save

  # identifiers { create_list(:identifier, 1) }
  # package { create(:package) }
  # metadata { [create(:metarecord), create(:metarecord, key: 'country', value: FFaker::Address.country)] }
end
