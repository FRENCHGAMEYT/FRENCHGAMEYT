'use strict';

const panel = document.getElementById('panel');
let state   = {};

// ── NUI messages ──────────────────────────────────
window.addEventListener('message', ({ data }) => {
    if (data.action === 'openMenu') {
        state = data.data;
        renderPanel();
        panel.classList.remove('hidden');
    } else if (data.action === 'closeMenu') {
        panel.classList.add('hidden');
    }
});

// ── Close ─────────────────────────────────────────
document.getElementById('close-btn').addEventListener('click', closeMenu);
document.addEventListener('keydown', e => { if (e.key === 'Escape') closeMenu(); });

function closeMenu() {
    panel.classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/closeMenu`, { method: 'POST', body: '{}' });
}

// ── Render header info ────────────────────────────
function renderPanel() {
    const on = !!state.onDuty;
    const pill = document.getElementById('panel-sub');
    pill.textContent = on ? '● EN SERVICE' : '● HORS SERVICE';
    pill.className   = on ? 'pill-on' : 'pill-off';
    document.getElementById('agent-grade').textContent = state.gradeLabel || '—';
    document.getElementById('agent-mat').textContent   = state.matricule  || '—';
}

// ── Action buttons ────────────────────────────────
document.querySelectorAll('.action-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        const action = btn.dataset.action;
        fetch(`https://${GetParentResourceName()}/policeAction`, {
            method: 'POST',
            body: JSON.stringify({ action })
        });
        closeMenu();
    });
});
