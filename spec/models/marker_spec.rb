require 'rails_helper'

RSpec.describe Marker, type: :model do
  describe "バリデーションのチェック" do
    it "設定したバリデーションが機能している場合有効であること" do
      marker = build(:marker)
      expect(marker).to be_valid
    end

    it "座標が存在しない場合無効であること" do
      marker = build(:marker, location: "")
      expect(marker).to be_invalid
    end

    it "順序が0未満の場合無効であること" do
      marker = build(:marker, order: -1)
      expect(marker).to be_invalid
    end
    
    it "順序とコースの組み合わせが一意でない場合無効であること" do
      marker = create(:marker)
      marker_with_duplicated_order_and_course_id = build(:marker, order: marker.order, course_id: marker.course_id)
      expect(marker_with_duplicated_order_and_course_id).to be_invalid
    end

    it "順序とコースの組み合わせが一意である場合有効であること" do
      marker = create(:marker)
      marker_with_another_order_and_course_id = build(:marker, order: marker.order + 1, course_id: marker.course_id)
      expect(marker_with_another_order_and_course_id).to be_valid
    end
  end
end
