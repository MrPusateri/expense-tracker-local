---
paths:
  - "src/spese/adapters/importers/**"
  - "tests/fixtures/**"
  - "tests/**/test_*import*.py"
---

# Importer degli export (docs/03)

- Non leggere mai gli export reali. Lavora sulla struttura descritta in `docs/03-fonti-dati.md` e sulle fixture sintetiche in `tests/fixtures/`. Se un dettaglio del formato non è documentato, chiedimelo.
- Le fixture si generano con uno script (`tests/fixtures/make_fixtures.py`) con esercenti, importi e date inventati. Mai copiare righe vere, nemmeno anonimizzate a mano.
- Intestazioni normalizzate (decodifica entità HTML come `Importo &euro;`, minuscole, spazi), mai confrontate col testo esatto. Ordine delle colonne irrilevante.
- `transaction_id`:
  - Satispay: `sp:` + ID nativo;
  - conto e prepagata: `v1:` + sha256(fonte | data | importo | causale **grezza**) + `:` + indice di occorrenza nel file.
  - Cambiare la regola vuol dire nuovo prefisso e migrazione delle label: chiedimelo prima.
- Righe non definitive (`⏳ In corso`, stato diverso da `Cont.`) scartate dall'importer. `❌ Annullato` conservato nel bronze.
- Per ogni importer serve il test di stabilità: due export sovrapposti per mesi interi producono gli stessi ID sulle righe comuni.
- `Tipo` e `Stato` Satispay si mappano con un dizionario esplicito, togliendo le emoji prima del confronto.
