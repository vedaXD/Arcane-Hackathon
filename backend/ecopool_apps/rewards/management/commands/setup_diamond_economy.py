from django.core.management.base import BaseCommand
from ecopool_apps.rewards.models import ConversionRate, NGOPartner, RedemptionOption


class Command(BaseCommand):
    help = 'Setup initial Diamond Economy data: conversion rates, NGOs, and redemption options'

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('💎 Setting up Diamond Economy...'))
        
        # Create Conversion Rates
        self.stdout.write('\n📊 Creating conversion rates...')
        rates = [
            {'name': 'CO2_TO_DIAMOND', 'rate': 10.0, 'description': 'Diamonds earned per kg of CO2 saved'},
            {'name': 'KM_TO_DIAMOND', 'rate': 2.0, 'description': 'Diamonds earned per kilometer traveled'},
            {'name': 'DONATION_TO_DIAMOND', 'rate': 5.0, 'description': 'Diamonds earned per rupee donated'},
            {'name': 'RUPEE_TO_CO2', 'rate': 0.1, 'description': 'kg CO2 offset per rupee donated'},
        ]
        
        for rate_data in rates:
            rate, created = ConversionRate.objects.get_or_create(
                name=rate_data['name'],
                defaults={
                    'rate': rate_data['rate'],
                    'description': rate_data['description'],
                    'active': True
                }
            )
            if created:
                self.stdout.write(self.style.SUCCESS(f'  ✅ Created: {rate_data["name"]} = {rate_data["rate"]}'))
            else:
                self.stdout.write(f'  ⏭️  Exists: {rate_data["name"]}')
        
        # Create NGO Partners
        self.stdout.write('\n🌱 Creating NGO partners...')
        ngos = [
            {
                'name': 'Green Earth Foundation',
                'description': 'Focused on reforestation and clean energy projects across India. Planting trees and promoting sustainable living.',
                'focus_area': 'Reforestation',
                'website': 'https://greenearthfoundation.org',
            },
            {
                'name': 'Clean Air Initiative',
                'description': 'Working to reduce air pollution in urban areas through awareness and action.',
                'focus_area': 'Air Quality',
                'website': 'https://cleanairinitiative.org',
            },
            {
                'name': 'Solar For All',
                'description': 'Promoting solar energy adoption in rural communities to reduce carbon footprint.',
                'focus_area': 'Clean Energy',
                'website': 'https://solarforall.org',
            },
            {
                'name': 'Ocean Cleanup Project',
                'description': 'Dedicated to removing plastic waste from oceans and protecting marine life.',
                'focus_area': 'Ocean Conservation',
                'website': 'https://oceancleanup.org',
            },
        ]
        
        for ngo_data in ngos:
            ngo, created = NGOPartner.objects.get_or_create(
                name=ngo_data['name'],
                defaults={
                    **ngo_data,
                    'verified': True,
                    'active': True,
                }
            )
            if created:
                self.stdout.write(self.style.SUCCESS(f'  ✅ Created: {ngo_data["name"]}'))
            else:
                self.stdout.write(f'  ⏭️  Exists: {ngo_data["name"]}')
        
        # Create Redemption Options
        self.stdout.write('\n🎁 Creating redemption options...')
        redemptions = [
            {
                'title': 'Amazon ₹500 Voucher',
                'description': 'Get ₹500 off on Amazon shopping. Valid for all products.',
                'category': 'VOUCHER',
                'diamond_cost': 400,
                'value': 500,
                'partner_name': 'Amazon India',
                'terms_conditions': 'Valid for 90 days from redemption. Non-transferable. One-time use only.',
                'validity_days': 90,
                'stock_available': 100,
                'featured': True,
            },
            {
                'title': 'Flipkart ₹1000 Voucher',
                'description': 'Get ₹1000 off on Flipkart. Shop for anything you love!',
                'category': 'VOUCHER',
                'diamond_cost': 850,
                'value': 1000,
                'partner_name': 'Flipkart',
                'terms_conditions': 'Valid for 90 days. Applicable on all categories.',
                'validity_days': 90,
                'stock_available': 50,
                'featured': True,
            },
            {
                'title': 'Zomato 50% Off (Up to ₹200)',
                'description': 'Get 50% discount on your next Zomato order',
                'category': 'DISCOUNT',
                'diamond_cost': 150,
                'value': 200,
                'partner_name': 'Zomato',
                'terms_conditions': 'Valid on orders above ₹400. One-time use.',
                'validity_days': 30,
                'stock_available': 200,
                'featured': False,
            },
            {
                'title': 'BookMyShow Movie Ticket',
                'description': 'Get 1 movie ticket absolutely free',
                'category': 'VOUCHER',
                'diamond_cost': 250,
                'value': 300,
                'partner_name': 'BookMyShow',
                'terms_conditions': 'Valid at any cinema. Subject to availability.',
                'validity_days': 60,
                'stock_available': 75,
                'featured': True,
            },
            {
                'title': 'Swiggy ₹100 Off',
                'description': 'Get ₹100 off on your Swiggy order',
                'category': 'DISCOUNT',
                'diamond_cost': 80,
                'value': 100,
                'partner_name': 'Swiggy',
                'terms_conditions': 'Minimum order ₹200. Valid for 30 days.',
                'validity_days': 30,
                'stock_available': 150,
                'featured': False,
            },
            {
                'title': 'Myntra ₹750 Voucher',
                'description': 'Shop fashion on Myntra with ₹750 off',
                'category': 'VOUCHER',
                'diamond_cost': 650,
                'value': 750,
                'partner_name': 'Myntra',
                'terms_conditions': 'Valid on fashion, footwear, and accessories.',
                'validity_days': 90,
                'stock_available': 60,
                'featured': True,
            },
            {
                'title': 'Uber Rides Worth ₹300',
                'description': 'Get ₹300 Uber credit for your rides',
                'category': 'VOUCHER',
                'diamond_cost': 250,
                'value': 300,
                'partner_name': 'Uber',
                'terms_conditions': 'Valid for 60 days. Can be used in multiple rides.',
                'validity_days': 60,
                'stock_available': 100,
                'featured': False,
            },
        ]
        
        for redemption_data in redemptions:
            redemption, created = RedemptionOption.objects.get_or_create(
                title=redemption_data['title'],
                defaults={
                    **redemption_data,
                    'active': True,
                }
            )
            if created:
                self.stdout.write(self.style.SUCCESS(
                    f'  ✅ Created: {redemption_data["title"]} - {redemption_data["diamond_cost"]} 💎'
                ))
            else:
                self.stdout.write(f'  ⏭️  Exists: {redemption_data["title"]}')
        
        self.stdout.write(self.style.SUCCESS('\n\n🎉 Diamond Economy setup complete!\n'))
        self.stdout.write('📊 Summary:')
        self.stdout.write(f'   • Conversion Rates: {ConversionRate.objects.count()}')
        self.stdout.write(f'   • NGO Partners: {NGOPartner.objects.filter(active=True).count()}')
        self.stdout.write(f'   • Redemption Options: {RedemptionOption.objects.filter(active=True).count()}')
        self.stdout.write('\n💎 "Carbon Crystals - The purest form of sustainable living" ✨\n')
