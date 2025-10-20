import consumer from "channels/consumer"

function setupSwitchChannel() {
  // URLが /weeks/:id/jobs のときだけ購読
<<<<<<< HEAD
  const match = window.location.pathname.match(/^\/weeks\/\d+\/jobs/)
=======
  const match = window.location.pathname.match(/^\/weeks\/\d+\/jobs(?:\/past)?$/)
>>>>>>> 82fe933 (復元)
  if (!match) return

  // グローバル購読（id関係なし）
  if (window.switchSubscription) return

  window.switchSubscription = consumer.subscriptions.create(
    { channel: "SwitchChannel" },
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

document.addEventListener("DOMContentLoaded", setupSwitchChannel)
document.addEventListener("turbo:load", setupSwitchChannel)
document.addEventListener("turbo:before-cache", () => {
  const overlay = document.getElementById("reload-overlay")
  if (overlay) overlay.remove()
})

function showReloadOverlay() {
  if (document.getElementById("reload-overlay")) return

  const overlay = document.createElement("div")
  overlay.className = "d-flex justify-content-center align-items-center position-fixed top-0 start-0 w-100 h-100 bg-dark bg-opacity-75 text-white"
  overlay.innerHTML = `
    <div class="text-center">
      <div class="spinner-border text-light" role="status" style="width: 4rem; height: 4rem;">
        <span class="visually-hidden">Loading...</span>
      </div>
      <div class="mt-3 fs-4">データ更新中</div>
    </div>
  `
  document.body.appendChild(overlay)
}
