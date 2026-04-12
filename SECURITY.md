# Politique de Sécurité — TérangaOS

## Versions supportées

| Version | Supportée |
|---------|-----------|
| 0.x (Alpha) | ⚠️ Support limité |
| 1.x (future) | ✅ Support complet |

## Signaler une vulnérabilité

**⚠️ Ne signalez JAMAIS une vulnérabilité de sécurité via une issue publique.**

### Comment signaler

1. Envoyez un email à **security@teranga-os.org**
2. Utilisez notre clé PGP (disponible sur `keys.teranga-os.org`)
3. Incluez :
   - Description de la vulnérabilité
   - Étapes de reproduction
   - Impact potentiel
   - Suggestion de correction (si possible)

### Délais de réponse

| Étape | Délai |
|-------|-------|
| Accusé de réception | 48h |
| Évaluation initiale | 7 jours |
| Correctif (critique) | 72h après confirmation |
| Correctif (important) | 30 jours |
| Correctif (faible) | 90 jours |

### Divulgation responsable

Nous suivons une politique de divulgation responsable de 90 jours. Après correction, nous publions un avis de sécurité dans `CHANGELOG.md` et via notre canal Matrix.

## Mesures de sécurité intégrées

TérangaOS intègre les mesures suivantes par défaut :

- Chiffrement disque complet (LUKS)
- AppArmor activé
- Firewall UFW activé
- Mises à jour de sécurité automatiques
- Pas de services réseau ouverts par défaut
- Pas de compte root distant

## Remerciements

Nous remercions publiquement (avec accord) les chercheurs en sécurité qui signalent des vulnérabilités de manière responsable.
