# 🚔 fivem-lspd

Script de job **LSPD** complet pour FiveM / GTA RP.

---

## Fonctionnalités

| Feature | Détail |
|---|---|
| **Prise de service** | Touche `F7` ou zone de service |
| **Menu interactif** | ox_lib context menu (`F6`) + NUI HTML (`/lspdui`) |
| **Tenues** | 6 tenues EUP (patrouille, detective, SWAT, DOA, moto, aviation) |
| **Unités spéciales** | Patrouille, Criminelle, SWAT, D.O.A., Cavalerie/Moto, K-9, Air Support |
| **Garage** | Véhicules addon (Ford PIU, Dodge Charger, BearCat, BMW motos, AS350...) |
| **Armurerie** | Armes addon filtrées par grade (Glock 17, Rem870, MP5, M4A1, HK416, Barrett...) |
| **Commissariats** | Mission Row, Sandy Shores, Paleto Bay |
| **Blips** | Marqueurs sur la carte pour chaque poste |
| **Zones** | Interaction automatique sur les points vestiaire / garage / armurerie |
| **Multi-framework** | ESX / QBCore / Standalone |

---

## Dépendances

```
ox_lib       >= 3.0
es_extended  >= 1.9  (si framework = 'esx')
qb-core              (si framework = 'qb')
oxmysql              (optionnel)
```

---

## Mods à télécharger

### Tenues — EUP
- **EUP for FiveM** : https://forum.cfx.re/t/emergency-uniform-pack/97599

### Véhicules addon
| Modèle | Lien |
|---|---|
| Ford PIU 2020 | https://www.gta5-mods.com/vehicles/2020-ford-police-interceptor-utility-lspd |
| Dodge Charger PPV | https://www.gta5-mods.com/vehicles/2020-dodge-charger-pursuit |
| Chevy Tahoe PPV | https://www.gta5-mods.com/vehicles/2020-chevrolet-tahoe-ppv-lspd |
| Lenco BearCat | https://www.gta5-mods.com/vehicles/lenco-bearcat-swat-vehicle |
| BMW R1200RT | https://www.gta5-mods.com/vehicles/bmw-r1200rt-police |
| Airbus AS350 | https://www.gta5-mods.com/vehicles/airbus-as350-police |

### Armes addon
| Arme | Lien |
|---|---|
| Glock 17 Gen5 | https://www.gta5-mods.com/weapons/glock-17-gen-5 |
| Remington 870 | https://www.gta5-mods.com/weapons/remington-870-police-magnum |
| HK MP5 | https://www.gta5-mods.com/weapons/hk-mp5-add-on |
| M4A1 | https://www.gta5-mods.com/weapons/m4a1-add-on |
| HK416 | https://www.gta5-mods.com/weapons/hk416-add-on |
| Barrett M107 | https://www.gta5-mods.com/weapons/barrett-m107a1 |

---

## Installation

1. Dossier `fivem-lspd` → `resources/`
2. `server.cfg` : `ensure ox_lib` puis `ensure fivem-lspd`
3. `shared/config.lua` → régler `Config.Framework` et `Config.JobName`
4. Installer les mods addon dans vos resources

---

## Commandes

| Touche / Commande | Action |
|---|---|
| `F6` | Menu LSPD (ox_lib) |
| `F7` | Prise / fin de service |
| `/lspdui` | Menu NUI (interface HTML) |
| `/lspdmenu` | Alias menu |
| `/lspdduty` | Alias service |

---

Développé par **FrenchGameYT**
