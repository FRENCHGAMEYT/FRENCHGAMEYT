Config = {}

-- ══════════════════════════════════════════════
--  GÉNÉRAL
-- ══════════════════════════════════════════════
Config.Locale        = 'fr'
Config.Framework     = 'esx'    -- 'esx' | 'qb' | 'standalone'
Config.JobName       = 'police'

Config.MenuKey       = 'F6'
Config.DutyKey       = 'F7'
Config.SpawnDistance = 5.0

-- ══════════════════════════════════════════════
--  GRADES
-- ══════════════════════════════════════════════
Config.Grades = {
    [0]  = { label = 'Stagiaire',         shortLabel = 'STG' },
    [1]  = { label = 'Agent',             shortLabel = 'AGT' },
    [2]  = { label = 'Agent Confirmé',    shortLabel = 'AGC' },
    [3]  = { label = 'Brigadier',         shortLabel = 'BRG' },
    [4]  = { label = 'Brigadier-Chef',    shortLabel = 'BRC' },
    [5]  = { label = 'Capitaine',         shortLabel = 'CAP' },
    [6]  = { label = 'Commandant',        shortLabel = 'CDT' },
    [7]  = { label = 'Commissaire',       shortLabel = 'COM' },
    [8]  = { label = 'Directeur',         shortLabel = 'DIR' },
    [9]  = { label = 'Chef de la Police', shortLabel = 'CDP' },
}

-- ══════════════════════════════════════════════
--  UNITÉS SPÉCIALES
-- ══════════════════════════════════════════════
Config.Units = {
    {
        id          = 'patrol',
        label       = 'Patrouille',
        description = 'Unité de patrouille classique',
        icon        = '🚔',
        minGrade    = 0,
        color       = '#3498db',
    },
    {
        id          = 'detective',
        label       = 'Brigade Criminelle',
        description = 'Unité d\'investigation et de détection',
        icon        = '🔍',
        minGrade    = 3,
        color       = '#9b59b6',
    },
    {
        id          = 'swat',
        label       = 'SWAT',
        description = 'Special Weapons And Tactics',
        icon        = '⚡',
        minGrade    = 4,
        color       = '#e74c3c',
    },
    {
        id          = 'doa',
        label       = 'D.O.A.',
        description = 'Division des Opérations Avancées',
        icon        = '🎯',
        minGrade    = 5,
        color       = '#e67e22',
    },
    {
        id          = 'mounted',
        label       = 'Cavalerie / Moto',
        description = 'Unité de patrouille moto',
        icon        = '🏍️',
        minGrade    = 2,
        color       = '#27ae60',
    },
    {
        id          = 'k9',
        label       = 'Unité K-9',
        description = 'Unité cynophile — maîtres-chiens',
        icon        = '🐕',
        minGrade    = 2,
        color       = '#1abc9c',
    },
    {
        id          = 'air',
        label       = 'Air Support',
        description = 'Unité aérienne — hélicoptères',
        icon        = '🚁',
        minGrade    = 4,
        color       = '#2980b9',
    },
}

-- ══════════════════════════════════════════════
--  TENUES — EUP Emergency Uniforms Pack
--
--  MOD À TÉLÉCHARGER :
--  → EUP for FiveM : https://forum.cfx.re/t/emergency-uniform-pack-law-enforcement-fire-ems/97599
--  → EUP Uniforms  : https://www.gta5-mods.com/player/eup-emergency-uniforms-pack-law-enforcement-fire-ems
--
--  Une fois installé, les composants EUP remplacent
--  certains indices du modèle freemode.
--  Ajustez drawable/texture selon votre pack EUP.
-- ══════════════════════════════════════════════
Config.Outfits = {

    -- ── Tenue Patrouille (EUP — LSPD Class A) ────
    -- EUP Component : chemise LSPD manches longues + pantalon cargo
    patrol = {
        label  = 'Tenue Patrouille',
        gender = {
            male = {
                { component = 1,  drawable = 0,   texture = 0  }, -- masque
                { component = 3,  drawable = 4,   texture = 0  }, -- bras (EUP gloves)
                { component = 4,  drawable = 35,  texture = 0  }, -- jambes (EUP cargo pants)
                { component = 5,  drawable = 45,  texture = 0  }, -- sac
                { component = 6,  drawable = 24,  texture = 0  }, -- chaussures (rangers noires)
                { component = 7,  drawable = 0,   texture = 0  }, -- accessoires
                { component = 8,  drawable = 58,  texture = 0  }, -- sous-vêtement (EUP undershirt)
                { component = 9,  drawable = 0,   texture = 0  }, -- gilet balistique
                { component = 10, drawable = 0,   texture = 0  }, -- badge
                { component = 11, drawable = 55,  texture = 0  }, -- haut (EUP LSPD shirt)
            },
            female = {
                { component = 1,  drawable = 0,   texture = 0  },
                { component = 3,  drawable = 4,   texture = 0  },
                { component = 4,  drawable = 34,  texture = 0  },
                { component = 5,  drawable = 45,  texture = 0  },
                { component = 6,  drawable = 24,  texture = 0  },
                { component = 7,  drawable = 0,   texture = 0  },
                { component = 8,  drawable = 57,  texture = 0  },
                { component = 9,  drawable = 0,   texture = 0  },
                { component = 10, drawable = 0,   texture = 0  },
                { component = 11, drawable = 48,  texture = 0  },
            },
        },
        props = {
            male   = { { prop = 0, drawable = 25, texture = 0 } }, -- casquette LSPD
            female = { { prop = 0, drawable = 25, texture = 0 } },
        },
    },

    -- ── Tenue Détective (EUP — Civil + badge) ────
    detective = {
        label  = 'Tenue Detective',
        gender = {
            male = {
                { component = 1,  drawable = 0,  texture = 0 },
                { component = 3,  drawable = 1,  texture = 0 },
                { component = 4,  drawable = 21, texture = 0 }, -- pantalon de ville
                { component = 5,  drawable = 0,  texture = 0 },
                { component = 6,  drawable = 10, texture = 0 }, -- chaussures de ville
                { component = 7,  drawable = 0,  texture = 0 },
                { component = 8,  drawable = 15, texture = 0 },
                { component = 9,  drawable = 0,  texture = 0 },
                { component = 10, drawable = 0,  texture = 0 },
                { component = 11, drawable = 15, texture = 0 }, -- veste banalisée
            },
            female = {
                { component = 1,  drawable = 0,  texture = 0 },
                { component = 3,  drawable = 1,  texture = 0 },
                { component = 4,  drawable = 20, texture = 0 },
                { component = 5,  drawable = 0,  texture = 0 },
                { component = 6,  drawable = 10, texture = 0 },
                { component = 7,  drawable = 0,  texture = 0 },
                { component = 8,  drawable = 15, texture = 0 },
                { component = 9,  drawable = 0,  texture = 0 },
                { component = 10, drawable = 0,  texture = 0 },
                { component = 11, drawable = 15, texture = 0 },
            },
        },
        props = {
            male   = { { prop = 0, drawable = -1, texture = 0 } }, -- pas de casquette
            female = { { prop = 0, drawable = -1, texture = 0 } },
        },
    },

    -- ── Tenue SWAT (EUP — Tactical BDU) ──────────
    -- EUP Component : combinaison tactique noire + gilet lourd
    swat = {
        label  = 'Tenue SWAT',
        gender = {
            male = {
                { component = 1,  drawable = 0,  texture = 0 },
                { component = 3,  drawable = 0,  texture = 0 },
                { component = 4,  drawable = 24, texture = 0 }, -- pantalon tactique noir
                { component = 5,  drawable = 0,  texture = 0 },
                { component = 6,  drawable = 24, texture = 0 }, -- bottes tactiques
                { component = 7,  drawable = 0,  texture = 0 },
                { component = 8,  drawable = 0,  texture = 0 },
                { component = 9,  drawable = 14, texture = 0 }, -- gilet lourd (EUP heavy vest)
                { component = 10, drawable = 0,  texture = 0 },
                { component = 11, drawable = 0,  texture = 0 }, -- haut tactique
            },
            female = {
                { component = 1,  drawable = 0,  texture = 0 },
                { component = 3,  drawable = 0,  texture = 0 },
                { component = 4,  drawable = 23, texture = 0 },
                { component = 5,  drawable = 0,  texture = 0 },
                { component = 6,  drawable = 24, texture = 0 },
                { component = 7,  drawable = 0,  texture = 0 },
                { component = 8,  drawable = 0,  texture = 0 },
                { component = 9,  drawable = 14, texture = 0 },
                { component = 10, drawable = 0,  texture = 0 },
                { component = 11, drawable = 0,  texture = 0 },
            },
        },
        props = {
            male   = { { prop = 0, drawable = 19, texture = 0 } }, -- casque tactique
            female = { { prop = 0, drawable = 19, texture = 0 } },
        },
    },

    -- ── Tenue D.O.A. (EUP — All black ops) ───────
    doa = {
        label  = 'Tenue D.O.A.',
        gender = {
            male = {
                { component = 1,  drawable = 0,  texture = 0 },
                { component = 3,  drawable = 0,  texture = 0 },
                { component = 4,  drawable = 24, texture = 1 }, -- texture 1 = variante noire
                { component = 5,  drawable = 0,  texture = 0 },
                { component = 6,  drawable = 24, texture = 0 },
                { component = 7,  drawable = 0,  texture = 0 },
                { component = 8,  drawable = 0,  texture = 0 },
                { component = 9,  drawable = 14, texture = 1 },
                { component = 10, drawable = 0,  texture = 0 },
                { component = 11, drawable = 55, texture = 1 }, -- variante DOA
            },
            female = {
                { component = 1,  drawable = 0,  texture = 0 },
                { component = 3,  drawable = 0,  texture = 0 },
                { component = 4,  drawable = 23, texture = 1 },
                { component = 5,  drawable = 0,  texture = 0 },
                { component = 6,  drawable = 24, texture = 0 },
                { component = 7,  drawable = 0,  texture = 0 },
                { component = 8,  drawable = 0,  texture = 0 },
                { component = 9,  drawable = 14, texture = 1 },
                { component = 10, drawable = 0,  texture = 0 },
                { component = 11, drawable = 48, texture = 1 },
            },
        },
        props = {
            male   = { { prop = 0, drawable = 19, texture = 1 } }, -- casque noir
            female = { { prop = 0, drawable = 19, texture = 1 } },
        },
    },

    -- ── Tenue Moto (EUP — Motorcycle unit) ───────
    motorcycle = {
        label  = 'Tenue Moto',
        gender = {
            male = {
                { component = 1,  drawable = 0,  texture = 0 },
                { component = 3,  drawable = 11, texture = 0 }, -- gants moto
                { component = 4,  drawable = 35, texture = 0 }, -- pantalon motard
                { component = 5,  drawable = 45, texture = 0 },
                { component = 6,  drawable = 34, texture = 0 }, -- bottes motard
                { component = 7,  drawable = 0,  texture = 0 },
                { component = 8,  drawable = 58, texture = 0 },
                { component = 9,  drawable = 0,  texture = 0 },
                { component = 10, drawable = 0,  texture = 0 },
                { component = 11, drawable = 55, texture = 0 },
            },
            female = {
                { component = 1,  drawable = 0,  texture = 0 },
                { component = 3,  drawable = 11, texture = 0 },
                { component = 4,  drawable = 34, texture = 0 },
                { component = 5,  drawable = 45, texture = 0 },
                { component = 6,  drawable = 34, texture = 0 },
                { component = 7,  drawable = 0,  texture = 0 },
                { component = 8,  drawable = 57, texture = 0 },
                { component = 9,  drawable = 0,  texture = 0 },
                { component = 10, drawable = 0,  texture = 0 },
                { component = 11, drawable = 48, texture = 0 },
            },
        },
        props = {
            male   = { { prop = 0, drawable = 54, texture = 0 } }, -- casque moto
            female = { { prop = 0, drawable = 54, texture = 0 } },
        },
    },

    -- ── Tenue Aviation (EUP — Flight suit) ───────
    air = {
        label  = 'Tenue Aviation',
        gender = {
            male = {
                { component = 1,  drawable = 0,  texture = 0 },
                { component = 3,  drawable = 0,  texture = 0 },
                { component = 4,  drawable = 35, texture = 0 },
                { component = 5,  drawable = 0,  texture = 0 },
                { component = 6,  drawable = 24, texture = 0 },
                { component = 7,  drawable = 0,  texture = 0 },
                { component = 8,  drawable = 0,  texture = 0 },
                { component = 9,  drawable = 19, texture = 0 }, -- gilet aviation
                { component = 10, drawable = 0,  texture = 0 },
                { component = 11, drawable = 40, texture = 0 }, -- combinaison pilote
            },
            female = {
                { component = 1,  drawable = 0,  texture = 0 },
                { component = 3,  drawable = 0,  texture = 0 },
                { component = 4,  drawable = 34, texture = 0 },
                { component = 5,  drawable = 0,  texture = 0 },
                { component = 6,  drawable = 24, texture = 0 },
                { component = 7,  drawable = 0,  texture = 0 },
                { component = 8,  drawable = 0,  texture = 0 },
                { component = 9,  drawable = 19, texture = 0 },
                { component = 10, drawable = 0,  texture = 0 },
                { component = 11, drawable = 40, texture = 0 },
            },
        },
        props = {
            male   = { { prop = 0, drawable = 55, texture = 0 } }, -- casque pilote
            female = { { prop = 0, drawable = 55, texture = 0 } },
        },
    },
}

-- ══════════════════════════════════════════════
--  VÉHICULES ADDON (mods à télécharger)
--
--  COMMENT INSTALLER UN VÉHICULE ADDON :
--  1. Télécharger le mod sur gta5-mods.com
--  2. Copier le dossier du véhicule dans resources/[addon-vehicles]/
--  3. Ajouter dans fxmanifest.lua : data_file 'HANDLING_FILE' 'data/handling.meta'
--  4. Le spawn name (model) est indiqué dans vehicles.meta du mod
-- ══════════════════════════════════════════════
Config.Vehicles = {

    -- ── Patrouille ────────────────────────────────
    patrol = {
        label    = 'Véhicules Patrouille',
        vehicles = {
            {
                model  = 'fpiu20',     -- Ford Police Interceptor Utility 2020
                label  = 'Ford PIU 2020',
                plate  = 'LSPD01',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/2020-ford-police-interceptor-utility-lspd
            },
            {
                model  = 'charger20',  -- Dodge Charger PPV 2020
                label  = 'Dodge Charger PPV',
                plate  = 'LSPD02',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/2020-dodge-charger-pursuit
            },
            {
                model  = 'tahoe20',   -- Chevy Tahoe PPV 2020
                label  = 'Chevy Tahoe PPV',
                plate  = 'LSPD03',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/2020-chevrolet-tahoe-ppv-lspd
            },
            -- Fallback vanilla si mods non installés
            {
                model  = 'police',
                label  = 'Cruiser Vanilla (fallback)',
                plate  = 'LSPD04',
                color1 = 0, color2 = 0,
            },
        },
    },

    -- ── Brigade Criminelle ────────────────────────
    detective = {
        label    = 'Véhicules Banalisés',
        vehicles = {
            {
                model  = 'taurus2019', -- Ford Taurus banalisé
                label  = 'Ford Taurus Banalisé',
                plate  = 'DETCT1',
                color1 = 12, color2 = 12,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/2019-ford-taurus-detective
            },
            {
                model  = 'explorer19', -- Ford Explorer banalisé
                label  = 'Ford Explorer Banalisé',
                plate  = 'DETCT2',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/2019-ford-explorer-police-unmarked
            },
            -- Fallback vanilla
            {
                model  = 'police4',
                label  = 'Unmarked Cruiser (fallback)',
                plate  = 'DETCT3',
                color1 = 0, color2 = 0,
            },
        },
    },

    -- ── SWAT ─────────────────────────────────────
    swat = {
        label    = 'Véhicules SWAT',
        vehicles = {
            {
                model  = 'bearcat',   -- Lenco BearCat SWAT APC
                label  = 'Lenco BearCat',
                plate  = 'SWAT01',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/lenco-bearcat-swat-vehicle
            },
            {
                model  = 'swatvan',   -- SWAT Van / Fourgon d'intervention
                label  = 'Fourgon SWAT',
                plate  = 'SWAT02',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/swat-van-pack
            },
            {
                model  = 'fpiu20swat', -- PIU livrée SWAT
                label  = 'Ford PIU SWAT',
                plate  = 'SWAT03',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : utiliser le même pack que fpiu20, livrée SWAT
            },
            -- Fallback vanilla
            {
                model  = 'riot',
                label  = 'Riot Van (fallback)',
                plate  = 'SWAT04',
                color1 = 0, color2 = 0,
            },
        },
    },

    -- ── D.O.A. ───────────────────────────────────
    doa = {
        label    = 'Véhicules D.O.A.',
        vehicles = {
            {
                model  = 'suburban19',  -- Chevy Suburban noir ops
                label  = 'Suburban DOA',
                plate  = 'DOA001',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/2019-chevrolet-suburban-unmarked
            },
            {
                model  = 'sprinter18',  -- Mercedes Sprinter fourgon DOA
                label  = 'Sprinter DOA',
                plate  = 'DOA002',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/mercedes-sprinter-police-van
            },
            -- Fallback vanilla
            {
                model  = 'fbi2',
                label  = 'SUV DOA (fallback)',
                plate  = 'DOA003',
                color1 = 0, color2 = 0,
            },
        },
    },

    -- ── Cavalerie / Moto ─────────────────────────
    mounted = {
        label    = 'Véhicules Moto',
        vehicles = {
            {
                model  = 'hp4police',  -- BMW HP4 Race Police
                label  = 'BMW HP4 Police',
                plate  = 'MOTO01',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/bmw-hp4-race-police
            },
            {
                model  = 'r1200rtlspd', -- BMW R1200RT Police
                label  = 'BMW R1200RT Police',
                plate  = 'MOTO02',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/bmw-r1200rt-police
            },
            {
                model  = 'harleypd',   -- Harley Davidson Police
                label  = 'Harley Davidson Police',
                plate  = 'MOTO03',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/harley-davidson-road-king-police
            },
            -- Fallback vanilla
            {
                model  = 'policeb',
                label  = 'Moto Police (fallback)',
                plate  = 'MOTO04',
                color1 = 0, color2 = 0,
            },
        },
    },

    -- ── Air Support ───────────────────────────────
    air = {
        label    = 'Véhicules Aériens',
        vehicles = {
            {
                model  = 'as350police', -- Airbus AS350 Police
                label  = 'Airbus AS350 Police',
                plate  = 'AIR001',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/airbus-as350-police
            },
            {
                model  = 'bell206pd',  -- Bell 206 Police
                label  = 'Bell 206 Police',
                plate  = 'AIR002',
                color1 = 0, color2 = 0,
                -- TÉLÉCHARGER : https://www.gta5-mods.com/vehicles/bell-206-police-helicopter
            },
            -- Fallback vanilla
            {
                model  = 'polmav',
                label  = 'Police Maverick (fallback)',
                plate  = 'AIR003',
                color1 = 0, color2 = 0,
            },
        },
    },
}

-- ══════════════════════════════════════════════
--  ARMURERIE — Armes addon
--
--  ARMES ADDON À TÉLÉCHARGER :
--  → Glock 17 Gen5   : https://www.gta5-mods.com/weapons/glock-17-gen-5
--  → Sig P320        : https://www.gta5-mods.com/weapons/sig-sauer-p320
--  → AR-15 / M4A1    : https://www.gta5-mods.com/weapons/m4a1-add-on
--  → Remington 870   : https://www.gta5-mods.com/weapons/remington-870-police-magnum
--  → MP5 Police      : https://www.gta5-mods.com/weapons/hk-mp5-add-on
--  → HK416           : https://www.gta5-mods.com/weapons/hk416-add-on
--  → Barrett M107    : https://www.gta5-mods.com/weapons/barrett-m107a1
--
--  Les armes addon utilisent leur propre hash.
--  Pour les armes vanilla, utiliser les hash GTA V ci-dessous.
-- ══════════════════════════════════════════════
Config.Armory = {
    -- ── Armes de base (tous grades) ──────────────
    {
        weapon   = 'WEAPON_NIGHTSTICK',
        label    = 'Matraque',
        ammo     = 0,
        minGrade = 0,
        addon    = false,
    },
    {
        weapon   = 'WEAPON_STUNGUN',
        label    = 'Taser X26',
        ammo     = 1,
        minGrade = 0,
        addon    = false,
    },
    {
        weapon   = 'WEAPON_FLASHLIGHT',
        label    = 'Lampe torche',
        ammo     = 0,
        minGrade = 0,
        addon    = false,
    },

    -- ── Pistolets ─────────────────────────────────
    {
        weapon   = 'WEAPON_PISTOL',
        label    = 'Glock 17 (vanilla fallback)',
        ammo     = 60,
        minGrade = 0,
        addon    = false,
        note     = 'Remplacer par weapon_glock17 une fois le mod installé',
    },
    {
        weapon   = 'weapon_glock17',   -- Glock 17 Gen5 addon
        label    = 'Glock 17 Gen5',
        ammo     = 60,
        minGrade = 1,
        addon    = true,
        -- DL : https://www.gta5-mods.com/weapons/glock-17-gen-5
    },
    {
        weapon   = 'weapon_sigp320',   -- Sig Sauer P320 addon
        label    = 'Sig P320 (SWAT)',
        ammo     = 60,
        minGrade = 4,
        addon    = true,
        -- DL : https://www.gta5-mods.com/weapons/sig-sauer-p320
    },

    -- ── Fusils à pompe ────────────────────────────
    {
        weapon   = 'weapon_rem870',    -- Remington 870 addon
        label    = 'Remington 870',
        ammo     = 30,
        minGrade = 2,
        addon    = true,
        -- DL : https://www.gta5-mods.com/weapons/remington-870-police-magnum
    },
    {
        weapon   = 'WEAPON_PUMPSHOTGUN',
        label    = 'Shotgun (vanilla fallback)',
        ammo     = 30,
        minGrade = 2,
        addon    = false,
    },

    -- ── SMG / Carabines ───────────────────────────
    {
        weapon   = 'weapon_mp5police', -- HK MP5 addon
        label    = 'HK MP5',
        ammo     = 120,
        minGrade = 3,
        addon    = true,
        -- DL : https://www.gta5-mods.com/weapons/hk-mp5-add-on
    },
    {
        weapon   = 'weapon_m4a1',      -- M4A1 / AR-15 addon
        label    = 'AR-15 / M4A1',
        ammo     = 120,
        minGrade = 3,
        addon    = true,
        -- DL : https://www.gta5-mods.com/weapons/m4a1-add-on
    },
    {
        weapon   = 'weapon_hk416',     -- HK416 SWAT addon
        label    = 'HK416 (SWAT)',
        ammo     = 180,
        minGrade = 4,
        addon    = true,
        -- DL : https://www.gta5-mods.com/weapons/hk416-add-on
    },
    {
        weapon   = 'WEAPON_CARBINERIFLE',
        label    = 'Carabine (vanilla fallback)',
        ammo     = 120,
        minGrade = 3,
        addon    = false,
    },

    -- ── Sniper ────────────────────────────────────
    {
        weapon   = 'weapon_barrettm107', -- Barrett M107 addon
        label    = 'Barrett M107 (DOA)',
        ammo     = 20,
        minGrade = 5,
        addon    = true,
        -- DL : https://www.gta5-mods.com/weapons/barrett-m107a1
    },
    {
        weapon   = 'WEAPON_SNIPERRIFLE',
        label    = 'Sniper (vanilla fallback)',
        ammo     = 30,
        minGrade = 4,
        addon    = false,
    },

    -- ── Équipements spéciaux ──────────────────────
    {
        weapon   = 'WEAPON_SMOKEGRENADE',
        label    = 'Grenade fumigène',
        ammo     = 5,
        minGrade = 3,
        addon    = false,
    },
    {
        weapon   = 'WEAPON_FLASHGRENADE',
        label    = 'Grenade flash',
        ammo     = 5,
        minGrade = 4,
        addon    = false,
    },
    {
        weapon   = 'WEAPON_GRENADELAUNCHER',
        label    = 'Lance-grenades (SWAT)',
        ammo     = 10,
        minGrade = 6,
        addon    = false,
    },
}

-- ══════════════════════════════════════════════
--  COMMISSARIATS
-- ══════════════════════════════════════════════
Config.Locations = {
    missionRow = {
        label = 'Commissariat Mission Row',
        coords = vector3(441.4, -982.0, 30.7),
        heading = 0.0,
        blip = { sprite = 60, color = 3, scale = 0.9, label = 'LSPD — Mission Row' },
        dutyPoint      = vector3(441.4, -982.0, 30.7),
        clothingPoint  = vector3(439.0, -988.0, 30.7),
        vehiclePoint   = vector3(468.1, -1018.3, 28.1),
        vehicleHeading = 0.0,
        armoryPoint    = vector3(476.9, -1000.7, 26.0),
    },
    sandyShores = {
        label = 'Poste Sandy Shores',
        coords = vector3(1853.0, 3686.9, 34.3),
        heading = 210.0,
        blip = { sprite = 60, color = 3, scale = 0.7, label = 'LSPD — Sandy Shores' },
        dutyPoint      = vector3(1853.0, 3686.9, 34.3),
        clothingPoint  = vector3(1848.0, 3689.0, 34.3),
        vehiclePoint   = vector3(1858.0, 3675.5, 34.3),
        vehicleHeading = 210.0,
        armoryPoint    = vector3(1846.0, 3683.0, 34.3),
    },
    paletoBay = {
        label = 'Poste Paleto Bay',
        coords = vector3(-448.0, 6008.0, 31.7),
        heading = 0.0,
        blip = { sprite = 60, color = 3, scale = 0.7, label = 'LSPD — Paleto Bay' },
        dutyPoint      = vector3(-448.0, 6008.0, 31.7),
        clothingPoint  = vector3(-450.0, 6012.0, 31.7),
        vehiclePoint   = vector3(-440.0, 6002.0, 31.7),
        vehicleHeading = 0.0,
        armoryPoint    = vector3(-452.0, 6006.0, 31.7),
    },
}

Config.UI = {
    primaryColor = '#1a2332',
    accentColor  = '#3498db',
    dangerColor  = '#e74c3c',
    successColor = '#2ecc71',
    warningColor = '#f39c12',
    textColor    = '#ecf0f1',
}
