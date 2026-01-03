from django.apps import AppConfig


class RewardsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'ecopool_apps.rewards'
    
    def ready(self):
        import ecopool_apps.rewards.services  # Import signals
