alias vivid_preview_theme_all='for theme in $(vivid themes); do echo "Theme: $theme"; export LS_COLORS=$(vivid generate $theme); gls --color; echo; done'
