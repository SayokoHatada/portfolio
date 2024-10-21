// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap/dist/js/bootstrap"

document.addEventListener('DOMContentLoaded', () => {
  const form = document.querySelector('#correct-form');
  const correctionResult = document.getElementById("correction-result");

  if (form) {
    form.addEventListener('submit', (event) => {
      event.preventDefault(); // デフォルトの送信を防ぐ
      const formData = new FormData(form); // フォームデータを取得

      fetch(form.action, {
        method: 'PATCH',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.text();
      })
      .then(html => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');
        const result = doc.querySelector("#correction-result p strong");

        if (result && result.innerText.trim()) {
          correctionResult.innerHTML = `
            <p><strong>添削結果:</strong> ${result.innerText}</p>`;
        } else {
          correctionResult.innerHTML = `
            <p><strong>添削結果:</strong> 結果がありません。</p>`;
        }
      })
      .catch(error => {
        console.error('There was a problem with the fetch operation:', error);
        correctionResult.innerHTML = `
          <p>エラーが発生しました。</p>`;
      });
    });
  }
});
