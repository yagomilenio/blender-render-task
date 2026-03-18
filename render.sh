#!/usr/bin/env bash
set -euo pipefail

#-------argumentos
START=""
END=""
OUTPUT=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --start)  START="$2";  shift 2 ;;
        --end)    END="$2";    shift 2 ;;
        --output) OUTPUT="$2"; shift 2 ;;
        *) echo "Argumento desconocido: $1" >&2; exit 1 ;;
    esac
done

if [[ -z "$START" || -z "$END" ]]; then
    echo "Uso: bash render.sh --start FRAME --end FRAME [--output DIR]" >&2
    exit 1
fi

OUTPUT="${OUTPUT:-frames_${START}_${END}.tar.gz}"
mkdir -p "$(dirname "$OUTPUT")" 
TMP_DIR=$(mktemp -d)

BLEND=blender-4.1-splash.blend


#-----detectar-gpu

GPU_DEVICE="CPU"

if command -v nvidia-smi &>/dev/null; then	#nvidia
    GPU_DEVICE="CUDA"
elif command -v rocminfo &>/dev/null; then	#amd
    GPU_DEVICE="HIP"
elif command -v clinfo &>/dev/null; then	#estandard
    GPU_DEVICE="OPENCL"
fi


echo "Fichero : $BLEND"
echo "Frames  : $START -> $END"
echo "Output  : $OUTPUT"
echo "GPU     : $GPU_DEVICE"

blender-5.1.0-linux-x64/blender \
    --background "$BLEND" \
    --python-expr "import bpy; bpy.context.scene.cycles.samples = 32; bpy.context.view_layer.cycles.use_denoising=False" \
    --render-output "$TMP_DIR/" \
    --render-format PNG \
    --render-frame "${START}..${END}" \
    -- --cycles-device "$GPU_DEVICE"

tar -czf "$OUTPUT" -C "$TMP_DIR" .

rm -rf "$TMP_DIR"

echo "Frames $START–$END completados en $OUTPUT"
