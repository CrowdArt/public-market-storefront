module Spree
  class ProductCollection < Spree::Base
    STAFF_PICKS_NAME = 'Staff Picks'.freeze

    has_many :product_collections_products, class_name: 'Spree::ProductCollectionProduct', dependent: :destroy
    has_many :products, through: :product_collections_products, class_name: 'Spree::Product', source: :product

    has_attached_file :image, styles: { thumb: '180x300>' }, default_url: 'home/books.png'
    validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\z}

    scope :promoted, -> { where(promoted: true) }

    before_destroy :staff_picks?

    extend FriendlyId
    friendly_id :name, use: :slugged

    validates :name, presence: true

    def self.staff_picks
      find_by(name: STAFF_PICKS_NAME)
    end

    private

    def should_generate_new_friendly_id?
      slug.blank? || super
    end

    def staff_picks?
      return if name.casecmp(STAFF_PICKS_NAME) != 0
      errors.add(:base, I18n.t('activerecord.errors.models.spree/product_collection.staff_picks'))
      throw :abort
    end
  end
end
