


CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE utilisateurs (
    id SERIAL PRIMARY KEY,
    nom_complet VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    mot_passe VARCHAR(255) NOT NULL,
    tel VARCHAR(20),
    role_id INT NOT NULL,
    CONSTRAINT fk_utilisateur_role FOREIGN KEY (role_id) REFERENCES roles(id)
);


CREATE TABLE produits (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(150) NOT NULL,
    prix_vente NUMERIC(10, 2) NOT NULL CHECK (prix_vente >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock_actuel >= 0),
    seuil INT NOT NULL DEFAULT 5 CHECK (seuil_alerte >= 0)
);

CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    tel VARCHAR(20) NOT NULL UNIQUE,
    limite_credit NUMERIC(10, 2) DEFAULT 0.00 CHECK (limite_credit >= 0)
);

CREATE TABLE fournisseurs (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    tel VARCHAR(20) NOT NULL,
    adresse TEXT
);


CREATE TABLE modes_paiement (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE commandes (
    id SERIAL PRIMARY KEY,
    date_commande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    montant_total NUMERIC(10, 2) NOT NULL CHECK (montant_total >= 0),
    montant_paye NUMERIC(10, 2) NOT NULL DEFAULT 0.00 CHECK (montant_paye >= 0),
    est_credit BOOLEAN NOT NULL DEFAULT FALSE,
    client_id INT NOT NULL,
    mode_paiement_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    CONSTRAINT fk_commande_client FOREIGN KEY (client_id) REFERENCES clients(id),
    CONSTRAINT fk_commande_mode_paiement FOREIGN KEY (mode_paiement_id) REFERENCES modes_paiement(id),
    CONSTRAINT fk_commande_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
);

CREATE TABLE lignes_commandes (
    id SERIAL PRIMARY KEY,
    quantite INT NOT NULL CHECK (quantite > 0),
    prix_unitaire NUMERIC(10, 2) NOT NULL CHECK (prix_unitaire >= 0),
    commande_id INT NOT NULL,
    produit_id INT NOT NULL,
    CONSTRAINT fk_ligne_commande FOREIGN KEY (commande_id) REFERENCES commandes(id) ON DELETE CASCADE,
    CONSTRAINT fk_ligne_produit FOREIGN KEY (produit_id) REFERENCES produits(id)
);

CREATE TABLE dettes (
    id SERIAL PRIMARY KEY,
    montant_initial NUMERIC(10, 2) NOT NULL CHECK (montant_initial > 0),
    montant_restant NUMERIC(10, 2) NOT NULL CHECK (montant_restant >= 0),
    statut VARCHAR(30) NOT NULL DEFAULT 'EN_COURS',
    date_echeance TIMESTAMP,
    commande_id INT NOT NULL UNIQUE,
    CONSTRAINT fk_dette_commande FOREIGN KEY (commande_id) REFERENCES commandes(id) ON DELETE CASCADE
);

CREATE TABLE paiements_dettes (
    id SERIAL PRIMARY KEY,
    date_paiement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    montant NUMERIC(10, 2) NOT NULL CHECK (montant > 0),
    dette_id INT NOT NULL,
    mode_paiement_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    CONSTRAINT fk_paiement_dette FOREIGN KEY (dette_id) REFERENCES dettes(id) ON DELETE CASCADE,
    CONSTRAINT fk_paiement_mode FOREIGN KEY (mode_paiement_id) REFERENCES modes_paiement(id),
    CONSTRAINT fk_paiement_user FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
);


CREATE TABLE statuts_appro (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE approvisionnements (
    id SERIAL PRIMARY KEY,
    ref_bl VARCHAR(100) NOT NULL UNIQUE,
    date_appro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    montant_total NUMERIC(10, 2) NOT NULL CHECK (montant_total >= 0),
    fournisseur_id INT NOT NULL,
    statut_appro_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    CONSTRAINT fk_appro_fournisseur FOREIGN KEY (fournisseur_id) REFERENCES fournisseurs(id),
    CONSTRAINT fk_appro_statut FOREIGN KEY (statut_appro_id) REFERENCES statuts_appro(id),
    CONSTRAINT fk_appro_user FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
);

CREATE TABLE lignes_appros (
    id SERIAL PRIMARY KEY,
    qte_commande INT NOT NULL CHECK (qte_commande > 0),
    qte_recue INT NOT NULL DEFAULT 0 CHECK (qte_recue >= 0),
    prix_achat_unitaire NUMERIC(10, 2) NOT NULL CHECK (prix_achat_unitaire >= 0),
    approvisionnement_id INT NOT NULL,
    produit_id INT NOT NULL,
    CONSTRAINT fk_ligne_appro FOREIGN KEY (approvisionnement_id) REFERENCES approvisionnements(id) ON DELETE CASCADE,
    CONSTRAINT fk_ligne_appro_produit FOREIGN KEY (produit_id) REFERENCES produits(id)
);