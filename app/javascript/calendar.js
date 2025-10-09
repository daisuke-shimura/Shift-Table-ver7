document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('calendar-container');
  const header = container && container.querySelector('.calendar-grid.header');
  const titleEl = document.getElementById('calendar-title');
  if (!container || !header || !titleEl) return;

  let ticking = false;
  let prevMonth = null;

  function getRightmostDateCell() {
    const rect = container.getBoundingClientRect();
    const headerBottom = rect.top + container.offsetHeight / 2;
    const cells = Array.from(container.querySelectorAll('.date'));
    let candidate = null;
    let maxRight = -Infinity;

    for (const cell of cells) {
      const r = cell.getBoundingClientRect();
      // ヘッダー直下にかかるセルのみ対象（可視かつトップ行）
      if (r.top <= headerBottom && r.bottom >= headerBottom) {
        // 横方向にコンテナ内で見えているものを優先
        if (r.right > maxRight && r.right > rect.left && r.left < rect.right) {
          candidate = cell;
          maxRight = r.right;
        }
      }
    }
    return candidate;
  }

  function ensureLabel(cell) {
    let label = cell.querySelector('.date-label');
    if (!label) {
      label = document.createElement('span');
      label.className = 'date-label';
      // 既存の中身をラベルに移す（単純化：既存は日付テキストのみ前提）
      label.textContent = (cell.dataset && cell.dataset.date) ? cell.dataset.date.split('-').pop().replace(/^0/,'') : '';
      // 子を全部消して label を追加（必要なら既存構造を保持する実装に変更）
      while (cell.firstChild) cell.removeChild(cell.firstChild);
      cell.appendChild(label);
    }
    return label;
  }

  function syncCellsWithMonth(currentMonth) {
    const cells = container.querySelectorAll('.date');
    cells.forEach(cell => {
      const cellMonth = Number(cell.dataset && cell.dataset.month);
      if (!cell.dataset || !cell.dataset.date) return;
      const day = (cell.dataset.date.split('-')[2] || new Date(cell.dataset.date).getDate());
      const label = ensureLabel(cell);
      const newText = (cellMonth === currentMonth) ? String(Number(day)) : `${cellMonth}/${String(Number(day))}`;
      if (label.textContent !== newText) label.textContent = newText;
    });
  }

  function updateTitleAndCellsIfNeeded() {
    const dateCell = getRightmostDateCell();
    if (!dateCell || !dateCell.dataset) return;
    const currentMonth = Number(dateCell.dataset.month);
    if (Number.isNaN(currentMonth)) return;
    if (currentMonth === prevMonth) return; // 変化なければ何もしない（負荷軽減）
    prevMonth = currentMonth;
    titleEl.textContent = `${currentMonth}月`;
    syncCellsWithMonth(currentMonth);
  }

  function onScroll() {
    if (!ticking) {
      ticking = true;
      requestAnimationFrame(() => {
        updateTitleAndCellsIfNeeded();
        ticking = false;
      });
    }
  }

  container.addEventListener('scroll', onScroll, { passive: true });
  window.addEventListener('resize', () => requestAnimationFrame(updateTitleAndCellsIfNeeded));

  // 初期表示同期
  updateTitleAndCellsIfNeeded();
});