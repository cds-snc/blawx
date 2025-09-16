#!/usr/bin/env python
"""
Database initialization script for staging/production deployment.
This script ensures the database is properly migrated and initialized.
"""

import os
import sys
import django
from django.core.management import execute_from_command_line

if __name__ == '__main__':
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'blawx.settings_production')
    django.setup()

    from django.db import connection
    from django.core.management.color import no_style
    from django.db.migrations.executor import MigrationExecutor

    print("Checking database connection...")
    
    try:
        # Test database connection
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
        print("✅ Database connection successful")
    except Exception as e:
        print(f"❌ Database connection failed: {e}")
        sys.exit(1)

    # Check if migrations are needed
    executor = MigrationExecutor(connection)
    plan = executor.migration_plan(executor.loader.graph.leaf_nodes())
    
    if plan:
        print(f"🔄 Found {len(plan)} pending migrations. Running migrations...")
        try:
            # Run migrations
            execute_from_command_line(['manage.py', 'migrate', '--noinput'])
            print("✅ Migrations completed successfully")
        except Exception as e:
            print(f"❌ Migration failed: {e}")
            sys.exit(1)
    else:
        print("✅ No migrations needed - database is up to date")

    # Ensure Sites framework is properly initialized
    try:
        from django.contrib.sites.models import Site
        site, created = Site.objects.get_or_create(
            id=1,
            defaults={'domain': 'blawx.cdssandbox.xyz', 'name': 'Blawx Staging'}
        )
        if created:
            print("✅ Created default Site object")
        else:
            print("✅ Default Site object already exists")
    except Exception as e:
        print(f"⚠️  Site initialization warning: {e}")

    print("🚀 Database initialization completed successfully!")