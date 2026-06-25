'use strict';

const overlay   = document.getElementById('overlay');
const dutyPill  = document.getElementById('duty-pill');
const dutyBtn   = document.getElementById('duty-btn');
let state = {};

// ── NUI messages ──────────────────────────────────
window.addEventListener('message', ({ data }) => {
    if (data.action === 'openMenu') {
        state = data.data;
        renderAll();
        overlay.classList.remove('hidden');
    } else if (data.action === 'closeMenu') {
        overlay.classList.add('hidden');
    }
});

// ── Close ─────────────────────────────────────────
document.getElementById('close-btn').addEventListener('click', closeMenu);
document.addEventListener('keydown', e => { if (e.key === 'Escape') closeMenu(); });

function closeMenu() {
    overlay.classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/closeMenu`, { method: 'POST', body: '{}' });
}

// ── Tabs ──────────────────────────────────────────
document.querySelectorAll('.tab').forEach(btn => {
    btn.addEventListener('click', () => {
        document.querySelectorAll('.tab').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.pane').forEach(p => p.classList.remove('active'));
        btn.classList.add('active');
        document.getElementById('pane-' + btn.dataset.tab).classList.add('active');
    });
});

// ── Duty toggle button ────────────────────────────
dutyBtn.addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/toggleDuty`, { method: 'POST', body: '{}' });
    closeMenu();
});

// ── Render ────────────────────────────────────────
function renderAll() {
    const on = !!state.onDuty;

    dutyPill.textContent = on ? '● EN SERVICE' : '● HORS SERVICE';
    dutyPill.className   = on ? 'pill-on' : 'pill-off';

    dutyBtn.textContent = on ? '⏻  Fin de service' : '⏻  Prise de service';
    dutyBtn.className   = on ? 'duty-btn-on' : 'duty-btn-off';

    document.getElementById('ab-matricule').textContent = state.matricule  || '—';
    document.getElementById('ab-grade').textContent     = state.gradeLabel || '—';
    document.getElementById('ab-unit').textContent      = state.currentUnit ? state.currentUnit.label : 'Aucune';

    renderUnits();
    renderOutfits();
    renderArmory();
}

function renderUnits() {
    const grid = document.getElementById('units-grid');
    grid.innerHTML = '';
    (state.units || []).forEach(unit => {
        const locked = state.grade < unit.minGrade;
        const active = state.currentUnit && state.currentUnit.id === unit.id;
        const card = document.createElement('div');
        card.className = 'card' + (locked ? ' locked' : '') + (active ? ' unit-active' : '');
        card.innerHTML = `
            <div class="card-icon">${unit.icon}</div>
            <div class="card-title">${unit.label}${active ? ' ✓' : ''}</div>
            <div class="card-desc">${unit.description}</div>
            ${locked ? `<div class="card-lock">🔒 Requis: ${unit.minGradeLabel}</div>` : ''}`;
        if (!locked) {
            card.addEventListener('click', () => {
                fetch(`https://${GetParentResourceName()}/selectUnit`, {
                    method: 'POST', body: JSON.stringify({ unitId: unit.id })
                });
                state.currentUnit = unit;
                renderAll();
            });
        }
        grid.appendChild(card);
    });
}

function renderOutfits() {
    const grid = document.getElementById('outfits-grid');
    grid.innerHTML = '';
    (state.outfits || []).forEach(outfit => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `<div class="card-icon">👔</div><div class="card-title">${outfit.label}</div>`;
        card.addEventListener('click', () => {
            fetch(`https://${GetParentResourceName()}/applyOutfit`, {
                method: 'POST', body: JSON.stringify({ outfitKey: outfit.key })
            });
        });
        grid.appendChild(card);
    });

    const civil = document.createElement('div');
    civil.className = 'card';
    civil.innerHTML = `<div class="card-icon">👕</div><div class="card-title">Tenue civile</div>`;
    civil.addEventListener('click', () => {
        fetch(`https://${GetParentResourceName()}/removeOutfit`, { method: 'POST', body: '{}' });
    });
    grid.appendChild(civil);
}

function renderArmory() {
    const list = document.getElementById('armory-list');
    list.innerHTML = '';
    (state.armory || []).forEach(weapon => {
        const locked = state.grade < weapon.minGrade;
        const item = document.createElement('div');
        item.className = 'list-item' + (locked ? ' locked' : '');
        item.innerHTML = `
            <span class="item-icon">${locked ? '🔒' : '🔫'}</span>
            <div>
                <div class="item-name">${weapon.label}</div>
                <div class="item-sub">${weapon.ammo > 0 ? weapon.ammo + ' munitions' : 'Corps à corps'}</div>
            </div>
            ${locked ? `<span class="item-grade">Grade requis: ${weapon.minGrade}</span>` : ''}`;
        if (!locked) {
            item.addEventListener('click', () => {
                fetch(`https://${GetParentResourceName()}/giveWeapon`, {
                    method: 'POST', body: JSON.stringify({ weapon: weapon.weapon, ammo: weapon.ammo })
                });
            });
        }
        list.appendChild(item);
    });
}
