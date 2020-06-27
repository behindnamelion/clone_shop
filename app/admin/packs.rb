ActiveAdmin.register Pack do
  index do
    selectable_column
    
    id_column
    
    column :image do |pack|
      if pack.image.attached?
        image_tag url_for(pack.image), class: "small-img"
      else
        "이미지 없음"
      end
    end
    column :product_name
    column :company_name
    column :desc
    column :price do |pack|
      number_to_currency(pack.price)
    end
    column :is_publish
    
    actions
    
  end
  
  
  # new, edit 커스텀하기
  form do |f|
  	f.inputs do
  	  f.input :image, as: :file
  	  f.input :product_name
  	  f.input :company_name
  	  f.input :desc
  	  f.input :price, hint: "실제 판매 가격을 입력해주세요."
      f.input :is_publish
    end
  f.actions
  end
  
  # show 부분 customize
  show do
    attributes_table do
      row :id
      row :image do |pack|
        if pack.image.attached?
          image_tag url_for(pack.image), class: "small-img"
        else
          "이미지 없음"
        end
      end
      row :product_name
      row :company_name
      row :desc
    end
  end
  
  scope :all
  scope -> { "공개" }, :published, default: true
  scope -> { "비공개" }, :unpublished
  
  batch_action :publish do |ids|
    @packs = Pack.where(id: ids)
    @packs.each do |pack|
      pack.update(is_publish: true)
    end
  	
  	flash[:notice] = "#{@packs.count}개의 마스크팩이 공개 처리되었습니다"
    redirect_back(fallback_location: root_path)
  end
  
  batch_action :unpublish do |ids|
    @packs = Pack.where(id: ids)
    @packs.each do |pack|
      pack.update(is_publish: false)
    end
  
    flash[:notice] = "#{@packs.count}개의 마스크팩이 비공개 처리되었습니다"
    redirect_back(fallback_location: root_path)
  end
  
end
