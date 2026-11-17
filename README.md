# chilen.dev

Static website for [Chilen](https://github.com/tpaau/chilen), built with
[Jekyll](https://jekyllrb.com) and vanilla CSS on top of a Material Design 3-style token system.

## Requirements

- Ruby + Bundler
- ImageMagick (for the image conversion script)

## Development

```bash
bundle exec jekyll serve
```

`.webp` files are not known to jekyll-serve's built-in web server; `_plugins/mime_types.rb`
registers the type locally, and
[Cloudflare Pages](https://developers.cloudflare.com/pages/) serves it correctly in production.

## Image pipeline

Screenshots live in `assets/screenshots/{light,dark}/` as PNG. After adding or changing any of them:

```bash
bash scripts/convert-to-webp.sh
```

This converts every PNG to WebP next to the original (originals are kept), regenerates
`assets/css/screenshots.css` with each image's aspect ratio, and prints the total size saved. The
markup picks up the WebP sources automatically.

## Fonts & icons

Fonts are preloaded per page via the `fonts:` front-matter list and gate the first paint; all faces
are stored as woff in `assets/fonts/`.

Icons are Material Symbols ligatures used as `<p class="icon filled">name</p>` (or `outlined`
without the `filled` class).

## Conventions

- Pages opt into extra stylesheets with `css: [...]` in front matter; the stylesheets are page-gated and never global unless truly shared.
- Styles live in page-scoped `<style>` tags for page-specific rules, some in shared components included in pages that use them, and in `assets/css/main.css` for globals.
- Design tokens (colors, spacing, icon sizes, easing) come from `assets/css/theme-{light,dark}.css` and the `:root` block in `main.css`; components only ever reference tokens, never hard-coded colors.
