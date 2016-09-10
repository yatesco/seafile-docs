# Two-Factor Authentication

Starting from version 6.0, we added Two-Factor Authentication to enhance account security.

There are two ways to enable this feature:

* System admin can ticking the check-box at "Password" section of system settings page, or

* just add `ENABLE_TWO_FACTOR_AUTH = True` to `seahub_settings.py` and restart service.

After that, there will be a "Two-Factor Authentication" section in user profile page.

Users can use Google Authenticator app on their smart-phone to scan the QR code.


## Twilio intergration

We also support text message method by using Twilio service.

First you need to install Twilio python library by

```
sudo pip install twilio
```

After that, append following lines to `seahub_settings.py`, 

```
TWO_FACTOR_SMS_GATEWAY = 'seahub_extra.two_factor.gateways.twilio.gateway.Twilio'
TWILIO_ACCOUNT_SID = '<your-account-sid>'
TWILIO_AUTH_TOKEN = '<your-auth-token>'
TWILIO_CALLER_ID = '<your-caller-id>'
EXTRA_MIDDLEWARE_CLASSES = (
    'seahub_extra.two_factor.gateways.twilio.middleware.ThreadLocals',
)
```

**Note**: if you already defined `EXTRA_MIDDLEWARE_CLASSES`, please replace `EXTRA_MIDDLEWARE_CLASSES = (` with `EXTRA_MIDDLEWARE_CLASSES += (`


After restarting, there will be "text message" method when user enable Two-Factor Authentication for their account.
