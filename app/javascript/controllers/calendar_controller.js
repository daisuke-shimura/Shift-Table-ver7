import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("CalendarController connected")

    this.container = this.element
    this.header = this.container.querySelector('.calendar-grid.header')
    this.titleEl = document.getElementById('calendar-title')
    if (!this.container || !this.header || !this.titleEl) return

    // 一度初期化済みならスキップ
    if (this.container.dataset.initialized) return
    this.container.dataset.initialized = "true"

    this.ticking = false
    this.prevMonth = null

    // イベント登録
    this.onScroll = this.onScroll.bind(this)
    this.onResize = this.onResize.bind(this)

    this.container.addEventListener('scroll', this.onScroll, { passive: true })
    window.addEventListener('resize', this.onResize)

    // 初期描画
    this.updateTitleAndCellsIfNeeded()
  }

  disconnect() {
    console.log("CalendarController disconnected")

    // イベント解除
    if (this.container) {
      this.container.removeEventListener('scroll', this.onScroll)
      window.removeEventListener('resize', this.onResize)
      this.container.removeAttribute('data-initialized')
    }
  }

  onScroll() {
    if (!this.ticking) {
      this.ticking = true
      requestAnimationFrame(() => {
        this.updateTitleAndCellsIfNeeded()
        this.ticking = false
      })
    }
  }

  onResize() {
    requestAnimationFrame(() => this.updateTitleAndCellsIfNeeded())
  }

  getRightmostDateCell() {
    const rect = this.container.getBoundingClientRect()
    const headerBottom = rect.top + this.container.offsetHeight / 2
    const cells = Array.from(this.container.querySelectorAll('.date'))
    let candidate = null
    let maxRight = -Infinity

    for (const cell of cells) {
      const r = cell.getBoundingClientRect()
      if (r.top <= headerBottom && r.bottom >= headerBottom) {
        if (r.right > maxRight && r.right > rect.left && r.left < rect.right) {
          candidate = cell
          maxRight = r.right
        }
      }
    }
    return candidate
  }

  ensureLabel(cell) {
    let label = cell.querySelector('.date-label')
    if (!label) {
      label = document.createElement('span')
      label.className = 'date-label'
      label.textContent = (cell.dataset && cell.dataset.date)
        ? cell.dataset.date.split('-').pop().replace(/^0/, '')
        : ''
      while (cell.firstChild) cell.removeChild(cell.firstChild)
      cell.appendChild(label)
    }
    return label
  }

  syncCellsWithMonth(currentMonth) {
    const cells = this.container.querySelectorAll('.date')
    cells.forEach(cell => {
      const cellMonth = Number(cell.dataset && cell.dataset.month)
      if (!cell.dataset || !cell.dataset.date) return
      const day = (cell.dataset.date.split('-')[2] || new Date(cell.dataset.date).getDate())
      const label = this.ensureLabel(cell)
      const newText = (cellMonth === currentMonth)
        ? String(Number(day))
        : `${cellMonth}/${String(Number(day))}`
      if (label.textContent !== newText) label.textContent = newText
    })
  }

  updateTitleAndCellsIfNeeded() {
    const dateCell = this.getRightmostDateCell()
    if (!dateCell || !dateCell.dataset) return
    const currentMonth = Number(dateCell.dataset.month)
    if (Number.isNaN(currentMonth)) return
    if (currentMonth === this.prevMonth) return
    this.prevMonth = currentMonth
    this.titleEl.textContent = `${currentMonth}月`
    this.syncCellsWithMonth(currentMonth)
  }
}
