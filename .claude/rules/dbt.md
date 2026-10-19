---
paths:
  - "dbt/**"
---

# dbt: silver e gold (ADR-002, ADR-004)

- Materializzazione `view` per silver e gold, finché ADR-004 non dice altro.
- `bronze`, `app` e `ml` sono dichiarati come `sources`; dbt non scrive mai in quegli schemi.
- Il silver non contiene mai categorie: deve restare rigenerabile dal solo bronze.
- `kind` si calcola nel silver in modo deterministico: `uscita`, `entrata`, `trasferimento_interno`, `prelievo_contante`.
- I trasferimenti interni si abbinano in `silver.transfer_pairs` (importo opposto, fonti diverse, ±2 giorni, parola chiave) e restano fuori dai totali e dal training.
- Nel gold la precedenza è fissa: label manuale → regola deterministica → regola esercente → modello. La colonna `category_source` dice da dove arriva.
- Le metriche "spesa lorda", "spesa netta" ed "entrate" si definiscono filtrando per segno, non per categoria (punto critico 9).
- Ogni modello ha test `unique`/`not_null` sulla chiave; le colonne a dominio chiuso hanno `accepted_values`.
