# Build image
bash build_image.bash

# Build container
bash build_container.bash

# Stop the container
docker-compose down

# Start with updated config
docker-compose up -d

# Verify it's running
docker-compose ps

# Enter the container
docker-compose exec codex-arch bash
