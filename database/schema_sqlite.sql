
PRAGMA foreign_keys = ON;

CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL UNIQUE
);

CREATE TABLE utilisateurs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom_complet TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    mot_passe TEXT NOT NULL,
    tel TEXT,
    role_id INTEGER NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE produits (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    libelle TEXT NOT NULL,
    prix_vente REAL NOT NULL CHECK (prix_vente >= 0),
    stock_actuel INTEGER NOT NULL DEFAULT 0 CHECK (stock_actuel >= 0),
    seuil_alerte INTEGER NOT NULL DEFAULT 5 CHECK (seuil_alerte >= 0)
);

CREATE TABLE clients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    prenom TEXT NOT NULL,
    email TEXT UNIQUE,
    tel TEXT NOT NULL UNIQUE,
    limite_credit REAL DEFAULT 0.00 CHECK (limite_credit >= 0)
);

CREATE TABLE fournisseurs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    email TEXT,
    tel TEXT NOT NULL,
    adresse TEXT
);

CREATE TABLE modes_paiement (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    libelle TEXT NOT NULL UNIQUE
);

CREATE TABLE commandes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_commande TEXT DEFAULT CURRENT_TIMESTAMP,
    montant_total REAL NOT NULL CHECK (montant_total >= 0),
    montant_paye REAL NOT NULL DEFAULT 0.00 CHECK (montant_paye >= 0),
    est_credit INTEGER NOT NULL DEFAULT 0 CHECK (est_credit IN (0, 1)),
    client_id INTEGER NOT NULL,
    mode_paiement_id INTEGER NOT NULL,
    utilisateur_id INTEGER NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (mode_paiement_id) REFERENCES modes_paiement(id),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
);

CREATE TABLE lignes_commandes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    quantite INTEGER NOT NULL CHECK (quantite > 0),
    prix_unitaire REAL NOT NULL CHECK (prix_unitaire >= 0),
    commande_id INTEGER NOT NULL,
    produit_id INTEGER NOT NULL,
    FOREIGN KEY (commande_id) REFERENCES commandes(id) ON DELETE CASCADE,
    FOREIGN KEY (produit_id) REFERENCES produits(id)
);

CREATE TABLE dettes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    montant_initial REAL NOT NULL CHECK (montant_initial > 0),
    montant_restant REAL NOT NULL CHECK (montant_restant >= 0),
    statut TEXT NOT NULL DEFAULT 'EN_COURS',
    date_echeance TEXT,
    commande_id INTEGER NOT NULL UNIQUE,
    FOREIGN KEY (commande_id) REFERENCES commandes(id) ON DELETE CASCADE
);

CREATE TABLE paiements_dettes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_paiement TEXT DEFAULT CURRENT_TIMESTAMP,
    montant REAL NOT NULL CHECK (montant > 0),
    dette_id INTEGER NOT NULL,
    mode_paiement_id INTEGER NOT NULL,
    utilisateur_id INTEGER NOT NULL,
    FOREIGN KEY (dette_id) REFERENCES dettes(id) ON DELETE CASCADE,
    FOREIGN KEY (mode_paiement_id) REFERENCES modes_paiement(id),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
);


CREATE TABLE statuts_appro (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL UNIQUE
);

CREATE TABLE approvisionnements (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ref_bl TEXT NOT NULL UNIQUE,
    date_appro TEXT DEFAULT CURRENT_TIMESTAMP,
    montant_total REAL NOT NULL CHECK (montant_total >= 0),
    fournisseur_id INTEGER NOT NULL,
    statut_appro_id INTEGER NOT NULL,
    utilisateur_id INTEGER NOT NULL,
    FOREIGN KEY (fournisseur_id) REFERENCES fournisseurs(id),
    FOREIGN KEY (statut_appro_id) REFERENCES statuts_appro(id),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
);

CREATE TABLE lignes_appros (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    qte_commande INTEGER NOT NULL CHECK (qte_commande > 0),
    qte_recue INTEGER NOT NULL DEFAULT 0 CHECK (qte_recue >= 0),
    prix_achat_unitaire REAL NOT NULL CHECK (prix_achat_unitaire >= 0),
    approvisionnement_id INTEGER NOT NULL,
    produit_id INTEGER NOT NULL,
    FOREIGN KEY (approvisionnement_id) REFERENCES approvisionnements(id) ON DELETE CASCADE,
    FOREIGN KEY (produit_id) REFERENCES produits(id)
);