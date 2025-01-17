#!/bin/bash

# Collect static files
#echo "Collect static files"
#python manage.py collectstatic --noinput

# ################################
# ##### configure crontab. #######
# ################################
#echo "Configure crontab."
#python manage.py crontab add
#python manage.py crontab add
#echo "Confirm crontab configuration."
#python manage.py crontab show
# ################################

set -o xtrace
set -e
set -o pipefail

if [ -d "$SRC_DIR"  ]; then
    echo "$SRC_DIR"
    cd $SRC_DIR
fi
# Check for ENV
if [ -z "$ENV" ]; then
    echo "ENV not set - we're in production"
    cp -f /code/storkbaby/storkbaby/settings_prod.py /code/storkbaby/storkbaby/settings.py
else
    echo "ENV = $ENV"
    cp -f /code/storkbaby/storkbaby/settings_dev.py /code/storkbaby/storkbaby/settings.py
    admin_password="viper123"
fi

# Apply database migrations
echo "Apply database migrations"
python /code/storkbaby/manage.py makemigrations storkbabyapp
python /code/storkbaby/manage.py migrate

# Set create admin user
echo "Creating super(admin) user"
python /code/storkbaby/manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@indexexchange.com', '$admin_password')" || \
python /code/storkbaby/manage.py shell -c "from django.contrib.auth.models import User; User.objects.filter(is_superuser=True); usr = User.objects.get(username='admin'); usr.set_password('$admin_password'); usr.save();"

# Start server
echo "Starting server"

if [ -z "$PORT" ]
then
      echo "PORT is empty..defaulting to 8080"
      PORT=8080
else
      echo "Heroku Assigned port is: $PORT"
fi
python /code/storkbaby/manage.py runserver 0.0.0.0:$PORT
