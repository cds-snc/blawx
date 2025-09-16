#!/bin/bash
set -e

echo "🚀 Starting Blawx Production Container..."

# Run database initialization
echo "🔄 Initializing database..."
python init_db.py

# Check if we should collect static files (only if not already done)
if [ ! -f "/app/staticfiles/.collected" ]; then
    echo "🔄 Collecting static files..."
    python manage.py collectstatic --noinput
    touch /app/staticfiles/.collected
    echo "✅ Static files collected"
else
    echo "✅ Static files already collected"
fi

# Load initial data if database is empty
echo "🔄 Loading initial data..."
python load_data.py || echo "⚠️  Initial data loading completed with warnings"

echo "🎉 Container initialization complete!"
echo "🚀 Starting Gunicorn server..."

# Start the main application
exec "$@"