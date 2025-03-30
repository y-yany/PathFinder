require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "バリデーションのチェック" do
    it "設定したバリデーションが機能していること" do
      course = build(:course)
      expect(course).to be_valid
    end

    it "タイトルがない場合無効であること" do
      course = build(:course, title: "")
      expect(course).to be_invalid
    end
    
    it "ルート（ポリライン）がない場合無効であること" do
      course = build(:course, encoded_polyline: "")
      expect(course).to be_invalid
    end
    
    it "ルート（ポリライン）が65,536文字以上の場合無効であること" do
      course = build(:course, encoded_polyline: "a" * 65_536)
      expect(course).to be_invalid
    end
    
    it "本文が1,001文字以上の場合無効であること" do
      course = build(:course, body: "a" * 1_001)
      expect(course).to be_invalid
    end
    
    it "距離が0未満または1,000以上の場合無効であること" do
      course_with_negative_distance = build(:course, distance: -1)
      expect(course_with_negative_distance).to be_invalid
      course_with_excessive_distance = build(:course, distance: 1_000)
      expect(course_with_excessive_distance).to be_invalid
    end
    
    it "所在地が256文字以上の場合無効であること" do
      course = build(:course, address: "a" * 256)
      expect(course).to be_invalid
    end
    
    it "ルート（ポリライン）が65,535文字以下の場合有効であること" do
      course = build(:course, encoded_polyline: "a" * 65_535)
      expect(course).to be_valid
    end
    
    it "本文が1,000文字以下の場合有効であること" do
      course = build(:course, body: "a" * 1_000)
      expect(course).to be_valid
    end
    
    it "距離が0以上999.99以下の場合有効であること" do
      course_with_non_negative_distance = build(:course, distance: 0)
      expect(course_with_non_negative_distance).to be_valid
      course_with_non_excessive_distance = build(:course, distance: 999.99)
      expect(course_with_non_excessive_distance).to be_valid
    end
    
    it "所在地が255文字以下の場合有効であること" do
      course = build(:course, address: "a" * 255)
      expect(course).to be_valid
    end
  end
end
