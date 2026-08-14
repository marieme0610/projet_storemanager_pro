### [Vendredi - Phase 1] : Conception & BDD Fallback
- **Heure de réalisation** : 20h
- **Ce qui a été fait** : 
Ce qui a été fait :
J’ai réalisé la modélisation des cas d’utilisation (use cases) pour les différents acteurs du système :

Administrateur Boutique
Chargé de Vente
Chargé de Stock
Inventaire
- **Difficultés / Obstacles** : 
J’ai rencontré quelques difficultés lors de la réalisation des diagrammes de cas d’utilisation. Au début, je pensais que certains acteurs devaient avoir des relations d’héritage entre eux. Après réflexion, j’ai finalement choisi de réaliser un diagramme séparé pour chaque acteur, car cela permet de mieux distinguer les responsabilités et les fonctionnalités propres à chacun.

J’ai également rencontré une difficulté lors de la conception du diagramme de classes. En analysant les écrans fournis, je n’ai pas trouvé de fonctionnalité permettant clairement d’enregistrer un fournisseur. Cela m’a posé quelques difficultés pour déterminer comment le fournisseur devait être représenté dans le modèle et quelles relations il devait avoir avec les autres entités du système. 


## [2026-08-14] - Correction et alignement du Diagramme de Classe UML

### 🎯 Objectif
Ajuster le diagramme de classe UML pour assurer une correspondance à 100% avec les exigences fonctionnelles du cahier des charges de *StoreManager Pro* (gestion des dettes, suivi des stocks et normes POO).

---

### Modifications effectuées

#### 
- **Remplacement de la classe `Reglement` par `Dette` et `PaiementDette`** :
  - *pourquoi:* : La version initiale ne permettait pas de gérer correctement les paiements. Désormais, une commande à crédit génère une `Dette`, et chaque versement du client est tracé via une entité `PaiementDette`.
  Dans l'ancienne diagramme, j'avais une une classe Reglement liée à Commande, mais dans le sujet du projet, en relisant j'ai remarqué que  l'element centrale exigée dans les Repositories et Services est Dette (voir DetteRepository.php, DebtService.php et les requêtes de remboursement) et a travers sa j'ai sue que je devais avoir une classe dette