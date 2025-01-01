# Translate text into any language
# Usage: trs :fr Hello
alias translate='trans '
# Translate text into french
# Usage: translate_to_fr "this is a house"
# Usage: translate_to_fr file://file.txt
# Usage: translate_to_fr https://google.com
# Usage: translate_to_fr --shell
alias translate_to_fr='trans :fr'
# Translate text into english
# Usage: translate_to_fr "this is a house"
# Usage: translate_to_fr file://file.txt
# Usage: translate_to_fr https://google.fr
# Usage: translate_to_fr --shell
alias translate_to_gb='trans :en-GB'
