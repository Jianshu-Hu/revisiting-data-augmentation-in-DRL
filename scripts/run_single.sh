identifier=$1
task=$2
aug_type=$3
for((i=0;i<3;i++)); do
    shift
done
seeds=($@)

num_train_frames=1000000
replay_buffer_num_workers=1

save_exps_dir="saved_exps"
if [ ! -d "$save_exps_dir" ]; then
    mkdir $save_exps_dir
    echo "Created save_exps: $save_exps_dir"
fi

task_id_dir="$save_exps_dir/$identifier-$task"
if [ ! -d "$task_id_dir" ]; then
    mkdir $task_id_dir
    echo "Created task_id_dir: $task_id_dir"
fi

aug_dir="$task_id_dir/aug$aug_type"
if [ ! -d "$aug_dir" ]; then
    mkdir $aug_dir
    echo "Created aug_dir: $aug_dir"
fi

current_date=$(date +%Y.%m.%d)
source_folder="exp_local/$current_date"

for seed in "${seeds[@]}"
do
    echo "Identifier $identifier: Start running $task with aug_type $aug_type and seed $seed"
    python train.py task=$task experiment=$task aug_type=$aug_type seed=$seed replay_buffer_num_workers=$replay_buffer_num_workers num_train_frames=$num_train_frames
    echo "Done running task $task with aug_type $aug_type and seed $seed"
done

find_aug_type="*aug_type=$aug_type*"
find_task="*task=$task*"
result_folders=$(find $source_folder -type d -name $find_aug_type -name $find_task)
mv $result_folders $aug_dir