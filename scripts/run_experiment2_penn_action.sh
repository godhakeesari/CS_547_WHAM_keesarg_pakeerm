cd ~/projects/CS_547_WHAM_keesarg_pakeerm || exit 1

source "$HOME/miniconda3/bin/activate" wham_dpvo

export PYTHONPATH=$PWD/third-party/DPVO:$PWD/third-party/ViTPose:$PYTHONPATH

cd dataset/PennAction || exit 1

FFMPEG=$(python -c "import imageio_ffmpeg as f; print(f.get_ffmpeg_exe())")

mkdir -p videos

# Selected PennAction clips:
# 0032 = baseball_pitch
# 0522 = bowling
# 0715 = clean_and_jerk
# 1173 = pullup
# 2218 = tennis_serve

for clip in 0032 0522 0715 1173 2218; do
 echo "Converting PennAction clip $clip to mp4..."
 "$FFMPEG" -y -framerate 30 \
   -i "frames/$clip/%06d.jpg" \
   -c:v libx264 -pix_fmt yuv420p \
   "videos/$clip.mp4"
done

cd ~/projects/CS_547_WHAM_keesarg_pakeerm || exit 1

for clip in 0032 0522 0715 1173 2218; do
 echo "Running WHAM + DPVO on PennAction clip $clip..."
 rm -rf "output/experiment2_penn_action/$clip"

 python demo.py \
   --video "dataset/PennAction/videos/$clip.mp4" \
   --output_pth "output/experiment2_penn_action/$clip" \
   --visualize
done

chmod +x scripts/run_experiment2_penn_action.sh
