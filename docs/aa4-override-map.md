# ActiveAdmin 4.0.0.beta22 — Override Map (Athena)

Discovered against the installed gem. **AA4 chrome is plain ERB partials** (not Arbre),
styled with Tailwind utility classes on a `gray`/`white` palette + `dark:` variants, and it
**already ships dark mode + a mobile drawer + dropdowns**.

## Already provided by AA4 (do NOT rebuild)
- **Dark/light toggle:** `_html_head.html.erb` has the FOUC script using
  `localStorage.theme` + `prefers-color-scheme`; `_site_header.html.erb` has a wired
  `.dark-mode-toggle` button. Both toggle `.dark` on `<html>` — matches Athena's
  `:root`/`.dark` token strategy. ⇒ **No theme Stimulus controller needed.**
- **Mobile nav drawer + dropdowns:** Flowbite JS (from `@activeadmin/activeadmin`) via
  `data-drawer-target="main-menu"`, `data-dropdown-toggle="user-menu"`. The `#main-menu`
  nav is `-translate-x-full xl:translate-x-0` (drawer below xl, fixed sidebar at xl+).
  ⇒ **No drawer/row-action controllers needed.**

## Athena's strategy
1. **Recolor by palette-token remap (primary).** In `athena_admin.css` `@theme`, redefine
   Tailwind's `--color-white` and `--color-gray-50…950` to warm Ember values. AA's existing
   `bg-white dark:bg-gray-950`, `text-gray-600`, `border-gray-200`, etc. then render Ember
   in both modes with zero partial edits.
2. **Targeted partial overrides** (place same-path file under `athena_admin/app/views/`; the
   engine prepends its view path so it wins over AA):
   - `active_admin/_site_header.html.erb` — ATHENA brand mark + fire; keep `.dark-mode-toggle`,
     `data-drawer-target`, `data-dropdown-toggle` hooks intact.
   - `active_admin/_main_navigation.html.erb` — fire active-item indicator (replace the
     gray `selected` highlight with a fire bar + wash); keep `data-*` menu hooks.
3. **Component classes** (already in `athena_admin.css`): `athena-btn-fire`, `athena-tag*`,
   `athena-num`, `athena-card`, `athena-fab`.

## Override points (exact paths under the AA gem `app/views/`)
- Layout: `layouts/active_admin.html.erb`, `layouts/active_admin_logged_out.html.erb`
- Chrome: `active_admin/_site_header`, `_main_navigation`, `_page_header`, `_sidebar`,
  `_site_footer`, `_flash_messages`, `_html_head`
- Resource: `active_admin/resource/_index_as_table_default.html.arb` (index table — **Arbre**),
  `_index_table_actions_default.html.erb`, `_form_default.html.arb`, `_show_default.html.arb`,
  `active_admin/resource/_active_filters.html.erb`
- Pagination: `active_admin/kaminari/_paginator.html.erb` (+ `_page`, `_next_page`, …)
- `status_tag`: Arbre component `ActiveAdmin::Views::Components::StatusTag` — restyle via
  emitted classes in CSS, or reopen the component.

## View-override mechanism
Engine initializer prepends `AthenaAdmin::Engine.root/app/views` to the controller view
paths so same-path files win over ActiveAdmin's. Verify in Phase 3 (integration test); if a
given template won't override cleanly, fall back to vendoring it into the host via the
installer.

## Index table → mobile cards
`_index_as_table_default.html.arb` is **Arbre**. Emitting `data-label` per cell requires
reopening the table builder. If heavy in beta22, fall back to horizontal-scroll on mobile
(wrap the table in an overflow container via CSS) and revisit card-restack later.
