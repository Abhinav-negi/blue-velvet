#!/usr/bin/env bash
# Fails if a feature imports another feature (package: or relative path).
# lib/router.dart is outside lib/features, so it may import every feature's routes.dart.
cd "$(dirname "$0")/.." || exit 1
bad=0
while IFS=: read -r file line rest; do
  own=$(sed -E 's#^lib/features/([^/]+)/.*#\1#' <<<"$file")
  uri=$(sed -E "s/.*['\"]([^'\"]+)['\"].*/\1/" <<<"$rest")
  case "$uri" in
    dart:*) continue ;;
    package:lynch/features/*) other=$(sed -E 's#package:lynch/features/([^/]+)/.*#\1#' <<<"$uri") ;;
    package:*) continue ;;
    *) target=$(realpath -m "$(dirname "$file")/$uri")
       case "$target" in
         "$PWD"/lib/features/*) other=$(sed -E "s#^$PWD/lib/features/([^/]+)/.*#\1#" <<<"$target") ;;
         *) continue ;;
       esac ;;
  esac
  if [ "$other" != "$own" ]; then
    echo "BOUNDARY VIOLATION: $file:$line ($own imports $other)"; bad=1
  fi
done < <(grep -rnE "^\s*(import|export|part)\s+['\"]" lib/features --include='*.dart')
exit $bad
