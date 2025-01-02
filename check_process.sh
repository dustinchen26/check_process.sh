#!/bin/bash

# 定義目標路徑
TARGET_DIR="/opt/compal_script"

# 定義檢查的腳本
STATUS_SCRIPTS=("get_cu_status.sh" "get_hiphy_status.sh" "get_duipc_status.sh" "get_du_status.sh")

# 定義目標結果
TARGET_RESULT='{"result":"2"}'
CHECK_RESULT='{"result":"3"}'

# 切換到目標路徑
cd "$TARGET_DIR" || {
  echo "Failed to change directory to $TARGET_DIR"
  exit 1
}

# 無窮迴圈檢查狀態
while :; do
  for script in "${STATUS_SCRIPTS[@]}"; do
    result=$(./$script 2>/dev/null)
    if [[ $result == "$CHECK_RESULT" ]]; then
      echo "Detected result '3' from $script. Executing stop and restart commands."

      # 停止 ran
      ./ran_stop.sh

      # 等待 30 秒
      echo "Waiting for 30 seconds..."
      sleep 30

      # 啟動 ran
      ./ran_start.sh

      # 記錄開始計時時間
      start_time=$(date +%s)

      # Polling 每個腳本直到結果為 {"result":"2"}
      for polling_script in "${STATUS_SCRIPTS[@]}"; do
        while :; do
          polling_result=$(./$polling_script 2>/dev/null)
          if [[ $polling_result == "$TARGET_RESULT" ]]; then
            break
          fi
          sleep 1 > /dev/null
        done
      done

      # 記錄結束計時時間並計算所需時間
      end_time=$(date +%s)
      elapsed_time=$((end_time - start_time))
      echo "All processes returned $TARGET_RESULT. Total time taken: $elapsed_time seconds."

      # 跳出檢查腳本的迴圈，進入下一輪
      break
    fi

    # 省略 Polling 過程的輸出
    if [[ $result != "$TARGET_RESULT" ]]; then
      continue
    fi
  done

  # 每次檢查後等待 1 分鐘
  echo "No process returned $CHECK_RESULT. Sleeping for 1 minute..."
  sleep 60
done
