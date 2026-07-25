
from django.conf import settings
from apps.users.models import User
from twilio.base.exceptions import TwilioRestException
from django.utils.translation import gettext_lazy as _
from twilio.rest import Client

Twilio_Client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
Twilio_Client_Verify = Twilio_Client.verify.v2.services.get(sid=settings.TWILIO_VERIFY_SERVICE_SID)



class TwilioVerifyPhoneService(VerifyPhoneServiceAbstract):
    def send(self, phone):
        user = User.objects.get(phone=phone)
        if settings.TWILIO_PREMIUM_ENABLED:
            Twilio_Client_Verify.verifications.create(to=phone, channel='sms', locale=user.language, custom_friendly_name=_('Otloha Sah'))
        else:
            Twilio_Client_Verify.verifications.create(to=phone, channel='sms', locale=user.language)


    def check(self, phone, code):
        try:
            result = Twilio_Client_Verify.verification_checks.create(to=phone, code=code)
        except TwilioRestException:
            return False
        return result.status == 'approved'
