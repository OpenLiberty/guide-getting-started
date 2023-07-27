sudo podman build \
  -t dev.local/getting-started-instanton \
  --cap-add=CHECKPOINT_RESTORE \
  --cap-add=SYS_PTRACE\
  --cap-add=SETPCAP \
  --security-opt seccomp=unconfined .
