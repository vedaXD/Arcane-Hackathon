"""
Management command to clean up expired chat messages (older than 24 hours)
Run this as a cron job: python manage.py cleanup_expired_chats
"""
from django.core.management.base import BaseCommand
from django.utils import timezone
from ecopool_apps.rides.models import ChatMessage


class Command(BaseCommand):
    help = 'Delete chat messages older than 24 hours'

    def handle(self, *args, **options):
        now = timezone.now()
        expired_messages = ChatMessage.objects.filter(expires_at__lt=now)
        count = expired_messages.count()
        
        if count > 0:
            expired_messages.delete()
            self.stdout.write(
                self.style.SUCCESS(f'✅ Deleted {count} expired chat messages')
            )
        else:
            self.stdout.write(
                self.style.SUCCESS('✅ No expired messages to delete')
            )
