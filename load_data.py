import os
import django
from pathlib import Path
from django.core import management


os.environ.setdefault("DJANGO_SETTINGS_MODULE", "blawx.settings")

django.setup()

source = Path.cwd() / "blawx" / "fixtures"

# Load all YAML and BLAWX files
for file in source.rglob("*.yaml"):
    try:
        management.call_command("loaddata", file)
    except Exception as e:
        print(f"Warning: Could not load {file}: {str(e)}")

for file in source.rglob("*.blawx"):
    try:
        management.call_command("loaddata", file)
    except Exception as e:
        print(f"Warning: Could not load {file}: {str(e)}")

# This import statement will fail if it is placed before the .setup() lines above.
from django.contrib.auth.models import Group

# Check if the group exists before creating it
try:
    if not Group.objects.filter(name="All users").exists():
        Group.objects.create(name="All users")
        print("Created 'All users' group")
    else:
        print("'All users' group already exists")
except Exception as e:
    print(f"Warning: Could not create 'All users' group: {str(e)}")
