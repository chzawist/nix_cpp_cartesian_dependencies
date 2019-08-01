for path in $(nix-build release.nix); do
  echo "===="
  echo "sha256sum of $path"
  find $path -type f | sort | xargs sha256sum | sha256sum | awk '{print $1}'
done
