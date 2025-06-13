import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal"];

  connect() {
    // モーダルを開く動作
    this.modalTarget.showModal();
  }

  // フォーム送信時に発火させるメソッド
  close(event) {
    // リクエストが成功したときtrueを返す
    if (event.detail.success) {
      this.modalTarget.close();
    }
  }
  
  // モーダルを閉じるメソッド
  closeModal() {
    this.modalTarget.close();
  }
}
