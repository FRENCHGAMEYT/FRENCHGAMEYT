'use strict';

const overlay = document.getElementById('lspd-overlay');
let state = {};

// ── NUI message listener ────────────────────────
window.addEventListener('message', (e) => {
    const { action, data } = e.data;
    if (action === 'openMenu') {
        state = data;
        renderAll();
        overlay.classList.remove('hidden');
    } else if (action === 'closeMenu') {
        overlay.classList.add('hidden');
    }
});

// ── Close button ─────────────────────────────
document.getElementById('close-btn').addEventListener('click', closeMenu);

document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeMenu();
});

function closeMenu() {
    overlay.classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST', body: JSON.stringify({})
    });
}

// ── Tab switching ─────────────────────────────
document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
        btn.classList.add('active');
        document.getElementById('tab-' + btn.dataset.tab).classList.add('active');
    });
});

// ── Render all ─────────────────────────────────
function renderAll() {
    const statusBadge = document.getElementById('status-badge');
    statusBadge.textContent = state.onDuty ? 'EN SERVICE' : 'HORS SERVICE';
    statusBadge.className = 'badge ' + (state.onDuty ? 'badge-online' : 'badge-offline');
    document.getElementById('grade-label').textContent = state.gradeLabel || '—';
    document.getElementById('unit-label').textContent = state.currentUnit ? state.currentUnit.label : 'Aucune unité';

    renderUnits();
    renderOutfits();
    renderVehicles();
    renderArmory();
    renderProfile();
}

function renderUnits() {
    const grid = document.getElementById('units-grid');
    grid.innerHTML = '';
    (state.units || []).forEach(unit => {
        const locked = state.grade < unit.minGrade;
        const active = state.currentUnit && state.currentUnit.id === unit.id;
        const card = document.createElement('div');
        card.className = 'card' + (locked ? ' locked' : '') + (active ? ' active-unit' : '');
        card.innerHTML = `<div class="card-icon">${unit.icon}</div>
            <div class="card-title">${unit.label}${active ? ' ✓' : ''}</div>
            <div class="card-desc">${unit.description}</div>
            ${locked ? `<div class="card-desc" style="color:#f39c12;margin-top:4px">🔒 ${unit.minGradeLabel}</div>` : ''}`;
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
        card.innerHTML = `<div class="card-icon">👔</div>
            <div class="card-title">${outfit.label}</div>`;
        card.addEventListener('click', () => {
            fetch(`https://${GetParentResourceName()}/applyOutfit`, {
                method: 'POST', body: JSON.stringify({ outfitKey: outfit.key })
            });
        });
        grid.appendChild(card);
    });

    const civilCard = document.createElement('div');
    civilCard.className = 'card';
    civilCard.innerHTML = `<div class="card-icon">👕</div><div class="card-title">Tenue civile</div>`;
    civilCard.addEventListener('click', () => {
        fetch(`https://${GetParentResourceName()}/removeOutfit`, { method: 'POST', body: JSON.stringify({}) });
    });
    grid.appendChild(civilCard);
}

function renderVehicles() {
    const container = document.getElementById('vehicle-categories');
    container.innerHTML = '';
    const vehicles = state.vehicles || {};
    Object.entries(vehicles).forEach(([catId, cat]) => {
        const section = document.createElement('div');
        section.className = 'veh-category';
        section.innerHTML = `<h3>${cat.label}</h3>`;
        const list = document.createElement('div');
        list.className = 'list-items';
        (cat.vehicles || []).forEach(v => {
            const item = document.createElement('div');
            item.className = 'list-item';
            item.innerHTML = `<span class="list-item-icon">🚗</span>
                <div><div class="list-item-label">${v.label}</div>
                <div class="list-item-sub">${v.model} · ${v.plate}</div></div>`;
            item.addEventListener('click', () => {
                fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
                    method: 'POST', body: JSON.stringify({ vehicleData: v })
                });
                closeMenu();
            });
            list.appendChild(item);
        });
        section.appendChild(list);
        container.appendChild(section);
    });
}

function renderArmory() {
    const list = document.getElementById('armory-list');
    list.innerHTML = '';
    (state.armory || []).forEach(weapon => {
        const locked = state.grade < weapon.minGrade;
        const item = document.createElement('div');
        item.className = 'list-item' + (locked ? ' locked' : '');
        item.innerHTML = `<span class="list-item-icon">${locked ? '🔒' : '🔫'}</span>
            <div><div class="list-item-label">${weapon.label}</div>
            <div class="list-item-sub">${weapon.ammo > 0 ? weapon.ammo + ' munitions' : 'Corps à corps'}</div></div>
            ${locked ? `<span class="list-item-grade">Grade requis: ${weapon.minGrade}</span>` : ''}`;
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

function renderProfile() {
    document.getElementById('info-matricule').textContent = state.matricule || '—';
    document.getElementById('info-grade').textContent = state.gradeLabel || '—';
    document.getElementById('info-status').textContent = state.onDuty ? 'En service ✅' : 'Hors service ❌';
    document.getElementById('info-unit').textContent = state.currentUnit ? state.currentUnit.label : 'Aucune';

    document.getElementById('duty-toggle-btn').addEventListener('click', () => {
        fetch(`https://${GetParentResourceName()}/toggleDuty`, { method: 'POST', body: JSON.stringify({}) });
        closeMenu();
    });
}
