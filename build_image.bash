docker-compose build   --build-arg USER_NAME=$(whoami)   --build-arg USER_ID=$(id -u)   --build-arg GROUP_ID=$(id -g)   --build-arg HOME_DIR=/home/$(whoami)/
