podman run \
  --rm \
  --cap-add=CHECKPOINT_RESTORE \
  --cap-add=SETPCAP \
  --security-opt seccomp=unconfined \
  -p 9080:9080 \
  dev.local/getting-started-instanton
