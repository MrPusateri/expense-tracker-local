---
paths:
  - "src/spese/domain/**"
  - "tests/unit/**"
---

# Dominio

- Classi pure (`dataclass` o classi semplici), testabili senza database.
- `Taxonomy` è l'aggregato delle categorie: valida unicità del nome, merge, deprecazione. Le categorie non si cancellano mai: diventano `deprecata` o `unita` con `merged_into`.
- Le categorie di sistema (`Trasferimento interno`, `Contante`) si possono rinominare ma non deprecare né unire.
- Una categoria può contenere sia uscite sia entrate (ADR-009): il segno sta nell'importo, non nella categoria.
- I command esprimono intenzioni all'imperativo (`LabelTransaction`), gli eventi fatti al passato (`TransactionLabeled`). Gli eventi si raccolgono sull'aggregato e li pubblica la UoW.
- Ogni invariante del dominio ha almeno un test unitario che la rompe e verifica l'eccezione.
