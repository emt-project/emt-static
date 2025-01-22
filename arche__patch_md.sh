#/bin/bash

echo "ingest metadata for for ${TOPCOLID} into ${ARCHE}"
docker run --rm \
  -v ${PWD}/arche_seed_files:/data \
  --network="host" \
  --entrypoint arche-import-metadata \
  acdhch/arche-ingest \
  /data/patch.ttl ${ARCHE} ${ARCHE_USER} ${ARCHE_PASSWORD}