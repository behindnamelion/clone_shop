class Pack < ApplicationRecord
    has_one_attached :image
    
    validates :product_name, :company_name, :price, presence: true
    validates :is_publish, exclusion: { in: [nil] }
    
    scope :published, -> { where(is_publish: true) }
    scope :unpublished, -> { where(is_publish: false) }
    
    def self.set_dummy_datas
      20.times do
        pack = self.new(
          product_name: Faker::Superhero.unique.name,
          company_name: Faker::Superhero.unique.power,
          desc: Faker::Lorem.unique.sentence,
          price: [2000, 3000, 4000].sample
        )
    
        pack.image.attach(io: open(Rails.root.join("lib", "assets", "sample.png")), filename: "sample.png")
        pack.save
      end
    end
    
end
