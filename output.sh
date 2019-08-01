for path in $(nix-build release.nix); do
  echo "===="
  echo "Output of $path/bin/main:"
  $path/bin/main
done
