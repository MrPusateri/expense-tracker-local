---
paths:
  - "src/spese/ml/**"
  - "src/spese/adapters/mlflow_classifier.py"
---

# Modello e MLflow (ADR-012)

- Tutto il preprocessing vive dentro una `sklearn.Pipeline` loggata su MLflow con la firma: niente trasformazioni fuori dal modello (punto critico 5).
- Il training legge solo `silver JOIN app.labels`. Mai le predizioni passate come etichette, mai le coppie di trasferimento.
- Split temporale, mai casuale. Classi con meno di 5 label escluse dal training.
- Champion e challenger si valutano sullo stesso test, ricalcolato a ogni training con le label rimappate dopo merge o rinomini (punto critico 6).
- Promozione solo se la macro-F1 migliora di almeno 1 punto. L'alias si chiama `champion`; il modello si carica come `models:/spese@champion`.
- Logga sempre `label_map.json` come artefatto.
- Nessun download a runtime: eventuali modelli di embedding si scaricano in fase di build dell'immagine.
- Per gli esperimenti usa solo dati sintetici.
