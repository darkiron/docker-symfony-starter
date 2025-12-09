# Docker Symfony Starter

Boilerplate prêt à l’emploi pour lancer Symfony derrière Caddy (HTTP) et PHP‑FPM (FastCGI) via Docker Compose.

## Sommaire
- Présentation rapide
- Prérequis
- Démarrage rapide
- Commandes utiles
- Structure du projet
- Git‑flow (branche `develop`)
- Dépannage (Caddy ⇄ PHP‑FPM ⇄ Symfony)

## Présentation
- Reverse proxy: Caddy
- Backend PHP: PHP‑FPM (Alpine, TCP 0.0.0.0:9000)
- Application Symfony montée dans le conteneur (dossier `app/`)
- Entrypoint qui peut installer un squelette Symfony si `composer.json` est absent (pack contrôlé par `SYMFONY_PACK`)

## Prérequis
- Docker Desktop 4.x+
- Git

## Démarrage rapide
```bash
docker compose up -d --build
open http://localhost
```

Variables utiles (fichier `.env` à la racine ou variables shell) :
- `PHP_TAG` (par défaut `8.5-fpm-alpine`)
- `SYMFONY_VERSION` (par défaut `8.0.x`)
- `SYMFONY_PACK`: `api` | `webapp` | `api-platform` (par défaut `api`)

Le dossier `app/` est ignoré par Git (sauf `app/.gitkeep`). Placez votre projet Symfony à l’intérieur de `app/`.

## Commandes utiles
- Logs Caddy: `docker compose logs -f caddy`
- Logs PHP‑FPM: `docker compose logs -f php`
- Shell PHP: `docker compose exec php sh`
- Console Symfony: `docker compose exec php php bin/console`

## Structure du projet
```
docker-symfony-starter/
├─ app/                  # code applicatif (ignoré par Git, sauf .gitkeep)
├─ docker/
│  ├─ caddy/Caddyfile    # config Caddy (file_server + php_fastcgi)
│  └─ php/
│     ├─ Dockerfile      # extensions PHP, composer, entrypoint
│     ├─ entrypoint.sh   # fix permissions + install skeleton (optionnel)
│     ├─ fpm.conf        # FPM écoute sur 0.0.0.0:9000
│     └─ php.ini         # réglages PHP de base
└─ compose.yaml          # services caddy + php
```

## Git‑flow
- Branche par défaut de dev: `develop`
- Travaillez dans des branches feature à partir de `develop`, ex. `feature/<scope>`

Exemple (création/MAJ de documentation):
```bash
git switch develop
git pull --ff-only
git switch -c feature/docs/readme
# … modifications …
git add -A
git commit -m "docs(readme): add project README 📘"
git push -u origin feature/docs/readme
# Ouvrez une PR vers develop
```

## Dépannage
1) 502 Caddy « dialing backend: lookup php »
- Vérifiez que le service `php` est UP/healthy: `docker compose ps`
- Le compose attend que PHP soit healthy (`depends_on.condition=service_healthy`).

2) FPM « Primary script unknown »
- L’entrypoint normalise les permissions de `/app` (lecture/traversée). Sur Windows, gardez `app/` accessible (755/644).

3) 404 applicative
- Caddy/PHP‑FPM OK mais Symfony renvoie 404: ajoutez une route d’accueil (ex. `HomeController`) ou utilisez le pack `webapp`.

## Licence
MIT
