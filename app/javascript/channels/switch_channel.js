import consumer from "channels/consumer"

function setupSwitchChannel() {
  const element = document.getElementById("week-container")
  if (!element) return

  const weekId = element.dataset.weekId
  // グローバルに保持して重複生成を防ぐ
  window.switchSubscriptions = window.switchSubscriptions || {}
  if (window.switchSubscriptions[weekId]) return

  window.switchSubscriptions[weekId] = consumer.subscriptions.create(
    { channel: "SwitchChannel", week_id: weekId },
    {
      received(data) {
        if (data.action === "reload") {
          showReloadOverlay()
          setTimeout(() => {
            window.location.reload()
          }, 1000)
        }
      }
    }
  )
}

// Turbo の初期ロードとページ遷移後の両方で初期化する
document.addEventListener("DOMContentLoaded", setupSwitchChannel)
document.addEventListener("turbo:load", setupSwitchChannel)

// Turbo がページをキャッシュする前にオーバーレイを消す（不要な場合は削除可）
document.addEventListener("turbo:before-cache", () => {
  const overlay = document.getElementById("reload-overlay")
  if (overlay) overlay.remove()
})

// 「更新中です」オーバーレイを表示する関数
function showReloadOverlay() {
  // すでに存在していたら再作成しない
  if (document.getElementById("reload-overlay")) return

  const overlay = document.createElement("div")
  overlay.id = "reload-overlay"
  overlay.style.position = "fixed"
  overlay.style.top = "0"
  overlay.style.left = "0"
  overlay.style.width = "100vw"
  overlay.style.height = "100vh"
  overlay.style.backgroundColor = "rgba(0,0,0,0.5)"
  overlay.style.display = "flex"
  overlay.style.justifyContent = "center"
  overlay.style.alignItems = "center"
  overlay.style.zIndex = "9999"
  overlay.style.color = "white"
  overlay.style.fontSize = "2rem"
  overlay.innerText = "データ更新中です..."

  document.body.appendChild(overlay)
}
